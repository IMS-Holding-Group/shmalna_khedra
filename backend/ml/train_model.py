import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.model_selection import train_test_split
from PIL import Image
import json

# إعدادات
IMG_SIZE = 224
BATCH_SIZE = 32
EPOCHS = 50
DATA_DIR = 'data/train'
MODEL_DIR = 'models'
CLASSES_FILE = 'plant_classes.json'

def create_model(num_classes):
    base_model = keras.applications.MobileNetV2(
        input_shape=(IMG_SIZE, IMG_SIZE, 3),
        include_top=False,
        weights='imagenet'
    )
    base_model.trainable = True
    
    # تجميد الطبقات الأولى
    for layer in base_model.layers[:-20]:
        layer.trainable = False
    
    model = keras.Sequential([
        base_model,
        layers.GlobalAveragePooling2D(),
        layers.Dropout(0.5),
        layers.Dense(512, activation='relu'),
        layers.Dropout(0.3),
        layers.Dense(num_classes, activation='softmax')
    ])
    
    model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=0.0001),
        loss='categorical_crossentropy',
        metrics=['accuracy', keras.metrics.TopKCategoricalAccuracy(k=3, name='top_3_accuracy')]
    )
    
    return model
    
    return model

def clean_corrupted_images():
    print("🔍 فحص الصور التالفة...")
    corrupted_count = 0
    
    if not os.path.exists(DATA_DIR):
        print(f"⚠️ مجلد البيانات غير موجود: {DATA_DIR}")
        return
    
    for plant_dir in os.listdir(DATA_DIR):
        plant_path = os.path.join(DATA_DIR, plant_dir)
        if not os.path.isdir(plant_path):
            continue
            
        for filename in os.listdir(plant_path):
            # دعم جميع امتدادات الصور
            if not filename.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.webp', '.jpe', '.bmp')):
                continue
                
            file_path = os.path.join(plant_path, filename)
            try:
                # محاولة فتح والتحقق من صحة الصورة
                with Image.open(file_path) as img:
                    img.verify()  # التحقق من صحة الصورة
                # إعادة فتح للتحقق الكامل
                with Image.open(file_path) as img:
                    img.load()  # تحميل الصورة بالكامل
            except Exception as e:
                # الصورة تالفة - حذفها فقط (لا المجلد)
                print(f"   ⚠️ حذف صورة تالفة: {plant_dir}/{filename}")
                try:
                    os.remove(file_path)
                    corrupted_count += 1
                except:
                    pass
    
    if corrupted_count > 0:
        print(f"✅ تم حذف {corrupted_count} صورة تالفة")
    else:
        print("✅ لا توجد صور تالفة")

def prepare_data():
    print("🔍 فحص البيانات...")
    
    if not os.path.exists(DATA_DIR):
        print(f"❌ مجلد البيانات غير موجود: {DATA_DIR}")
        print("💡 قم بتشغيل setup_data.py أولاً لإنشاء المجلدات")
        return None, None
    
    # تنظيف الصور التالفة قبل التدريب
    clean_corrupted_images()
    
    # إنشاء ImageDataGenerator مع التكبير
    datagen = ImageDataGenerator(
        rescale=1./255,
        rotation_range=15,
        width_shift_range=0.15,
        height_shift_range=0.15,
        shear_range=0.15,
        zoom_range=0.15,
        horizontal_flip=True,
        brightness_range=[0.8, 1.2],
        fill_mode='nearest',
        validation_split=0.2
    )
    
    try:
        train_generator = datagen.flow_from_directory(
            DATA_DIR,
            target_size=(IMG_SIZE, IMG_SIZE),
            batch_size=BATCH_SIZE,
            class_mode='categorical',
            subset='training',
            shuffle=True
        )
        
        val_generator = datagen.flow_from_directory(
            DATA_DIR,
            target_size=(IMG_SIZE, IMG_SIZE),
            batch_size=BATCH_SIZE,
            class_mode='categorical',
            subset='validation',
            shuffle=False
        )
    except Exception as e:
        print(f"❌ خطأ في تحميل البيانات: {e}")
        print("💡 تأكد من وجود صور صحيحة في المجلدات")
        return None, None
    
    # حفظ فئات النباتات
    class_names = list(train_generator.class_indices.keys())
    class_to_idx = train_generator.class_indices
    idx_to_class = {v: k for k, v in class_to_idx.items()}
    
    os.makedirs(MODEL_DIR, exist_ok=True)
    
    with open(os.path.join(MODEL_DIR, CLASSES_FILE), 'w', encoding='utf-8') as f:
        json.dump({
            'class_to_idx': class_to_idx,
            'idx_to_class': idx_to_class,
            'class_names': class_names
        }, f, ensure_ascii=False, indent=2)
    
    print(f"✅ تم العثور على {len(class_names)} فئة:")
    for name in class_names:
        print(f"   - {name}")
    
    return train_generator, val_generator

def train():
    print("🚀 بدء التدريب...")
    
    train_gen, val_gen = prepare_data()
    if train_gen is None:
        return
    
    num_classes = len(train_gen.class_indices)
    
    print(f"\n📊 معلومات التدريب:")
    print(f"   - عدد الفئات: {num_classes}")
    print(f"   - حجم الصورة: {IMG_SIZE}x{IMG_SIZE}")
    print(f"   - حجم الدفعة: {BATCH_SIZE}")
    print(f"   - عدد الدورات: {EPOCHS}")
    
    # إنشاء النموذج
    model = create_model(num_classes)
    model.summary()
    
    # Callbacks
    callbacks = [
        keras.callbacks.ModelCheckpoint(
            os.path.join(MODEL_DIR, 'plant_recognition_model.h5'),
            monitor='val_accuracy',
            save_best_only=True,
            verbose=1
        ),
        keras.callbacks.EarlyStopping(
            monitor='val_accuracy',
            patience=15,
            restore_best_weights=True,
            verbose=1
        ),
        keras.callbacks.ReduceLROnPlateau(
            monitor='val_loss',
            factor=0.5,
            patience=5,
            min_lr=0.00001
        )
    ]
    
    # التدريب
    print("\n🏋️ بدء التدريب...")
    try:
        history = model.fit(
            train_gen,
            epochs=EPOCHS,
            validation_data=val_gen,
            callbacks=callbacks,
            verbose=1
        )
    except Exception as e:
        print(f"\n❌ خطأ أثناء التدريب: {e}")
        print("💡 تأكد من وجود صور صحيحة في جميع المجلدات")
        return
    
    # حفظ النموذج النهائي
    model.save(os.path.join(MODEL_DIR, 'plant_recognition_model_final.h5'))
    
    print("\n✅ تم الانتهاء من التدريب!")
    print(f"   - أفضل دقة: {max(history.history['val_accuracy']):.2%}")
    print(f"   - النموذج محفوظ في: {MODEL_DIR}/")

if __name__ == '__main__':
    print("🌱 نظام تدريب التعرف على النباتات")
    print("=" * 50)
    train()

