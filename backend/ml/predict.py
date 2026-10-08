import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
from PIL import Image
import json
import io
from pathlib import Path

MODEL_DIR = 'models'
MODEL_FILE = 'plant_recognition_model.h5'
CLASSES_FILE = 'plant_classes.json'
PLANTS_DATA_FILE = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'plants_data.json')
IMG_SIZE = 224
MIN_CONFIDENCE = 0.1  # الحد الأدنى للثقة (10%) - أقل من ذلك يعتبر خطأ

class PlantRecognizer:
    def __init__(self):
        self.model = None
        self.class_to_idx = {}
        self.idx_to_class = {}
        self.class_names = []
        self.plants_database = []
        self.load_model()
        self.load_plants_database()
    
    def load_model(self):
        model_path = os.path.join(MODEL_DIR, MODEL_FILE)
        classes_path = os.path.join(MODEL_DIR, CLASSES_FILE)
        
        if not os.path.exists(model_path):
            print(f"⚠️ النموذج غير موجود: {model_path}")
            return False
        
        if not os.path.exists(classes_path):
            print(f"⚠️ ملف الفئات غير موجود: {classes_path}")
            return False
        
        try:
            # تحميل النموذج
            self.model = keras.models.load_model(model_path)
            print(f"✅ تم تحميل النموذج من: {model_path}")
            
            # تحميل الفئات
            with open(classes_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.class_to_idx = data['class_to_idx']
                self.idx_to_class = {int(k): v for k, v in data['idx_to_class'].items()}
                self.class_names = data['class_names']
            
            print(f"✅ تم تحميل {len(self.class_names)} فئة نباتية")
            return True
        except Exception as e:
            print(f"❌ خطأ في تحميل النموذج: {e}")
            return False
    
    def load_plants_database(self):
        try:
            if os.path.exists(PLANTS_DATA_FILE):
                with open(PLANTS_DATA_FILE, 'r', encoding='utf-8') as f:
                    self.plants_database = json.load(f)
                print(f"✅ تم تحميل {len(self.plants_database)} نبات من قاعدة البيانات")
            else:
                print(f"⚠️ ملف قاعدة البيانات غير موجود: {PLANTS_DATA_FILE}")
                self.plants_database = []
        except Exception as e:
            print(f"❌ خطأ في تحميل قاعدة البيانات: {e}")
            self.plants_database = []
    
    def preprocess_image(self, image_bytes):
        try:
            # فتح الصورة
            image = Image.open(io.BytesIO(image_bytes))
            
            # تحويل إلى RGB إذا لزم الأمر
            if image.mode != 'RGB':
                image = image.convert('RGB')
            
            # تغيير الحجم
            image = image.resize((IMG_SIZE, IMG_SIZE))
            
            # تحويل إلى مصفوفة numpy
            img_array = np.array(image)
            
            # تطبيع
            img_array = img_array.astype('float32') / 255.0
            
            # إضافة بُعد للدفعة
            img_array = np.expand_dims(img_array, axis=0)
            
            return img_array
        except Exception as e:
            print(f"❌ خطأ في معالجة الصورة: {e}")
            return None
    
    def find_plant_in_database(self, plant_name):
        if not self.plants_database:
            return None
        
        # البحث بالاسم الرئيسي
        for plant in self.plants_database:
            if plant.get('الاسم_الشائع_الرئيسي') == plant_name:
                return plant
            
            # البحث في الأسماء الشائعة الأخرى
            other_names = plant.get('الأسماء_الشائعة_الأخرى', [])
            if plant_name in other_names:
                return plant
            
            # البحث في الاسم العلمي
            scientific_name = plant.get('الاسم_العلمي_المختصر', '')
            if plant_name.lower() in scientific_name.lower():
                return plant
        
        return None
    
    def get_all_plants_from_database(self):
        if not self.plants_database:
            return []
        
        return [plant.get('الاسم_الشائع_الرئيسي', '') for plant in self.plants_database]
    
    def predict(self, image_bytes):
        # يجب أن يكون النموذج محملاً للتعرف على النبات
        if self.model is None:
            return {
                'success': False,
                'error': 'النموذج غير محمل',
                'message': 'يرجى التأكد من وجود النموذج المدرب في مجلد models/'
            }
        
        # استخدام النموذج فقط للتعرف على النبات
        return self._predict_with_model(image_bytes)
    
    def _predict_with_model(self, image_bytes):
        # معالجة الصورة
        img_array = self.preprocess_image(image_bytes)
        if img_array is None:
            return {
                'success': False,
                'error': 'خطأ في معالجة الصورة'
            }

        # التنبؤ
        try:
            predictions = self.model.predict(img_array, verbose=0)
            
            # الحصول على أفضل 3 توقعات
            top_indices = np.argsort(predictions[0])[-3:][::-1]
            
            # طباعة التوقعات للتشخيص
            print(f"\n🔍 توقعات النموذج:")
            for i, idx in enumerate(top_indices):
                conf = float(predictions[0][idx])
                plant_name = self.idx_to_class.get(idx, 'غير معروف')
                print(f"   {i+1}. {plant_name}: {conf*100:.2f}%")
            
            results = []
            for idx in top_indices:
                confidence = float(predictions[0][idx])
                if confidence > 0.01:  # تجاهل الاحتمالات المنخفضة جداً
                    plant_name = self.idx_to_class.get(idx, 'غير معروف')
                    plant_data = self.find_plant_in_database(plant_name)
                    
                    results.append({
                        'name': plant_name,
                        'confidence': confidence,
                        'confidence_percent': round(confidence * 100, 2),
                        'plant_data': plant_data
                    })
            
            if not results:
                return {
                    'success': False,
                    'error': 'لم يتم التعرف على النبات',
                    'message': 'النموذج لم يتمكن من التعرف على النبات في الصورة. تأكد من أن الصورة واضحة وتحتوي على نبات فعلي.',
                    'suggestions': 'تأكد من أن الصورة واضحة وتحتوي على نبات من النباتات المدربة'
                }
            
            # أفضل نتيجة
            top_result = results[0]
            
            # قبول التعرف حتى لو كانت الثقة منخفضة (لكن نعطي تحذير)
            if top_result['confidence'] < MIN_CONFIDENCE:
                return {
                    'success': True,
                    'plant_name': top_result['name'],
                    'confidence': top_result['confidence'],
                    'confidence_percent': top_result['confidence_percent'],
                    'alternatives': results[1:] if len(results) > 1 else [],
                    'plant_data': top_result.get('plant_data'),
                    'warning': f'مستوى الثقة {top_result["confidence_percent"]}% منخفض نسبياً. قد لا يكون التعرف دقيقاً تماماً.'
                }
            
            return {
                'success': True,
                'plant_name': top_result['name'],
                'confidence': top_result['confidence'],
                'confidence_percent': top_result['confidence_percent'],
                'alternatives': results[1:] if len(results) > 1 else [],
                'plant_data': top_result.get('plant_data')
            }
        except Exception as e:
            # في حالة الخطأ، فشل التعرف
            print(f"❌ خطأ في التنبؤ: {e}")
            return {
                'success': False,
                'error': f'خطأ في التنبؤ: {str(e)}',
                'message': 'حدث خطأ أثناء محاولة التعرف على النبات. تأكد من أن الصورة صحيحة وأن النموذج محمل بشكل صحيح.'
            }
    
    def _predict_from_database(self, image_bytes):
        if not self.plants_database:
            return {
                'success': False,
                'error': 'قاعدة البيانات غير متاحة',
                'suggestions': 'يرجى التأكد من وجود ملف plants_data.json'
            }
        
        # إرجاع قائمة بجميع النباتات المتاحة كبدائل
        all_plants = self.get_all_plants_from_database()
        
        return {
            'success': True,
            'plant_name': all_plants[0] if all_plants else 'غير معروف',
            'confidence': 0.5,  # ثقة متوسطة عند استخدام قاعدة البيانات فقط
            'confidence_percent': 50.0,
            'message': 'تم استخدام قاعدة البيانات للتعرف على النبات. النموذج المدرب غير متاح أو لم يتعرف على النبات.',
            'alternatives': [{'name': name, 'confidence': 0.3, 'confidence_percent': 30.0} for name in all_plants[1:6]],
            'all_available_plants': all_plants
        }

# إنشاء مثيل واحد للاستخدام
recognizer = PlantRecognizer()

