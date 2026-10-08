import os
import json
from pathlib import Path

DATA_DIR = 'data/train'
JSON_PATH = '../plants_data.json'

def load_plants_from_json():
    json_full_path = os.path.join(os.path.dirname(__file__), JSON_PATH)
    
    if not os.path.exists(json_full_path):
        print(f"❌ ملف JSON غير موجود: {json_full_path}")
        return []
    
    with open(json_full_path, 'r', encoding='utf-8') as f:
        plants_data = json.load(f)
    
    # استخراج الأسماء الشائعة الرئيسية
    plants = []
    for plant in plants_data:
        plant_name = plant.get('الاسم_الشائع_الرئيسي', '')
        if plant_name:
            plants.append(plant_name)
    
    return plants

def setup_directories():
    print("📁 قراءة النباتات من JSON...")
    
    # قراءة النباتات من JSON
    plants = load_plants_from_json()
    
    if not plants:
        print("❌ لم يتم العثور على نباتات في JSON")
        return
    
    print(f"✅ تم العثور على {len(plants)} نبات في JSON")
    
    # إنشاء المجلد الرئيسي للتدريب
    os.makedirs(DATA_DIR, exist_ok=True)
    
    # التحقق من المجلدات الموجودة
    existing_dirs = []
    if os.path.exists(DATA_DIR):
        existing_dirs = [d for d in os.listdir(DATA_DIR) 
                        if os.path.isdir(os.path.join(DATA_DIR, d))]
    
    print(f"\n📂 المجلدات الموجودة في train: {len(existing_dirs)}")
    
    # إنشاء مجلد لكل نبات من JSON (فقط إذا لم يكن موجوداً)
    print("\n📁 التحقق وإنشاء المجلدات المطلوبة...")
    created_count = 0
    existing_count = 0
    
    for plant in plants:
        plant_dir = os.path.join(DATA_DIR, plant)
        if os.path.exists(plant_dir):
            existing_count += 1
            # التحقق من وجود صور في المجلد
            images = [f for f in os.listdir(plant_dir) 
                     if f.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.webp', '.jpe'))]
            print(f"   ✅ موجود: {plant} ({len(images)} صورة)")
        else:
            os.makedirs(plant_dir, exist_ok=True)
            created_count += 1
            print(f"   🆕 تم إنشاء: {plant}")
    
    # التحقق من وجود النباتات الـ12 المطلوبة
    print(f"\n🔍 التحقق من النباتات الـ12 المطلوبة...")
    required_plants = set(plants)
    found_plants = set(existing_dirs)
    missing_plants = required_plants - found_plants
    
    if missing_plants:
        print(f"   ⚠️ نباتات مفقودة: {len(missing_plants)}")
        for plant in missing_plants:
            print(f"      - {plant}")
    else:
        print(f"   ✅ جميع النباتات الـ{len(required_plants)} موجودة!")
    
    print(f"\n📊 الملخص:")
    print(f"   - المجلدات الموجودة: {existing_count}")
    print(f"   - المجلدات الجديدة: {created_count}")
    print(f"   - إجمالي النباتات: {len(plants)}")
    
    print("\n📝 دليل استخدام:")
    print(f"1. ضع صور كل نبات في المجلد المناسب:")
    for plant in plants[:5]:  # عرض أول 5 فقط
        print(f"   {DATA_DIR}/{plant}/")
    if len(plants) > 5:
        print(f"   ... و {len(plants) - 5} نبات آخر")
    
    print(f"\n2. تأكد من وجود ملفات صور في كل مجلد")
    print(f"3. شغل سكريبت التدريب: python train_model.py")
    
    # التحقق من الصور الموجودة
    print("\n🔍 فحص الصور الموجودة...")
    for plant in plants:
        plant_dir = os.path.join(DATA_DIR, plant)
        if os.path.exists(plant_dir):
            images = [f for f in os.listdir(plant_dir) 
                     if f.lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.webp', '.jpe', '.bmp'))]
            print(f"   {plant}: {len(images)} صورة")
    
    print("\n💡 نصيحة: تحتاج 50-100 صورة على الأقل لكل نبات للتدريب الجيد")

if __name__ == '__main__':
    print("🌱 إعداد بيانات التدريب")
    print("=" * 50)
    setup_directories()

