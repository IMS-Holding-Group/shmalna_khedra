from flask import Flask, request, jsonify
from flask_cors import CORS
from predict import recognizer
import os

app = Flask(__name__)
CORS(app)

PORT = int(os.getenv('PORT', 5000))

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'running',
        'model_loaded': recognizer.model is not None,
        'num_classes': len(recognizer.class_names)
    })

@app.route('/recognize', methods=['POST'])
def recognize_plant():
    try:
        if 'image' not in request.files:
            return jsonify({
                'success': False,
                'error': 'لم يتم إرسال صورة'
            }), 400
        
        image_file = request.files['image']
        
        if image_file.filename == '':
            return jsonify({
                'success': False,
                'error': 'لم يتم تحديد ملف'
            }), 400
        
        # قراءة بيانات الصورة
        image_bytes = image_file.read()
        
        if len(image_bytes) == 0:
            return jsonify({
                'success': False,
                'error': 'الملف فارغ'
            }), 400
        
        # التعرف على النبات
        result = recognizer.predict(image_bytes)
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': f'خطأ في الخادم: {str(e)}'
        }), 500

@app.route('/classes', methods=['GET'])
def get_classes():
    # إرجاع النباتات من قاعدة البيانات إذا كانت متاحة
    if recognizer.plants_database:
        all_plants = recognizer.get_all_plants_from_database()
        return jsonify({
            'classes': all_plants,
            'count': len(all_plants),
            'source': 'database'
        })
    else:
        return jsonify({
            'classes': recognizer.class_names,
            'count': len(recognizer.class_names),
            'source': 'model'
        })
    
@app.route('/plants', methods=['GET'])
def get_all_plants():
    if recognizer.plants_database:
        return jsonify({
            'success': True,
            'plants': recognizer.plants_database,
            'count': len(recognizer.plants_database)
        })
    else:
        return jsonify({
            'success': False,
            'error': 'قاعدة البيانات غير متاحة',
            'count': 0
        })

if __name__ == '__main__':
    print("🌱 خدمة التعرف على النباتات")
    print(f"🔗 الخادم يعمل على المنفذ {PORT}")
    print(f"📡 API متاح على: http://localhost:{PORT}")
    app.run(host='0.0.0.0', port=PORT, debug=False)

