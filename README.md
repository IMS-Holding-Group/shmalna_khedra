# مشروع شمالنا خضراء: منصة مجتمعية للتعرف على النباتات البرية في عرعر

## 📚 دليل أكاديمي شامل للطلاب المبتدئين

تم تصميم هذا الدليل لتكون مرجعاً تعليمياً شاملاً للطلاب المبتدئين في البرمجة. يشرح كل جزء من المشروع بأسلوب مبسط ومفصل، مع ترجمة جميع المصطلحات التقنية إلى العربية.

---

## 📖 جدول المحتويات

1. [مقدمة المشروع](#-1-مقدمة-المشروع)
2. [نظرة عامة على التقنيات المستخدمة](#-2-نظرة-عامة-على-التقنيات-المستخدمة)
3. [البنية العامة للمشروع](#-3-البنية-العامة-للمشروع)
4. [شرح الواجهة الخلفية (Backend)](#-4-شرح-الواجهة-الخلفية-backend)
5. [شرح تطبيق الجوال (Mobile App)](#-5-شرح-تطبيق-الجوال-mobile-app)
6. [نظام الخريطة التفاعلية](#-6-نظام-الخريطة-التفاعلية)
7. [كيفية تدريب البيانات](#-7-كيفية-تدريب-البيانات)
8. [كيفية استخدام التطبيق](#-8-كيفية-استخدام-التطبيق)
9. [القاموس التقني](#-9-القاموس-التقني)
10. [إرشادات التطوير](#-10-إرشادات-التطوير)

---

## 🌱 1. مقدمة المشروع

### ما هو مشروع شمالنا خضراء؟

"شمالنا خضراء" هي منصة مجتمعية رقمية تعمل كتطبيق جوال، تهدف إلى:

1. **التعرف على النباتات البرية**: يساعد المستخدمين على التعرف على النباتات البرية في منطقة عرعر والمملكة العربية السعودية
2. **توثيق المواقع**: يسمح للمستخدمين بإضافة مواقع النباتات على الخريطة مع الصور والإحداثيات
3. **بناء مجتمع بيئي**: يشجع المجتمع على المساهمة في الحفاظ على النباتات البرية وحماية البيئة
4. **التثقيف البيئي**: يوفر معلومات شاملة عن الأهمية البيئية والفوائد الطبية للنباتات

### الهدف التعليمي للمشروع

هذا المشروع مصمم خصيصاً للطلاب المبتدئين لفهم:
- كيفية بناء تطبيق جوال متكامل
- التعامل مع قاعدة البيانات
- إنشاء واجهة برمجة تطبيقات (API)
- استخدام الخرائط في التطبيقات
- المصادقة والأمان في التطبيقات
- التفاعل بين الواجهة الخلفية وتطبيق الجوال

---

## 🛠️ 2. نظرة عامة على التقنيات المستخدمة

### الجزء الأول: الواجهة الخلفية (Backend)

#### 1. Node.js
- **التعريف**: بيئة تشغيل لبرمجة JavaScript خارج المتصفح
- **الاستخدام**: يسمح ببناء خوادم ويب قوية للتعامل مع البيانات
- **التشبيه**: مثل الطاهي في المطعم - يتلقى الطلبات ويجهزها ويعيدها
- **المثال**:
```javascript
console.log('مرحباً من Node.js!');
// يمكنك تشغيل هذا الكود في Terminal
```

#### 2. Express.js
- **التعريف**: إطار عمل لبناء واجهات برمجة تطبيقات (API)
- **الاستخدام**: يسهل إنشاء نقاط الاتصال (Endpoints) للتعامل مع البيانات
- **التشبيه**: مثل قائمة الطعام في المطعم - تحدد ما يمكن طلبه
- **المثال**:
```javascript
app.get('/api/plants', (req, res) => {
    res.json({ plants: 'قائمة النباتات' });
});
```

#### 3. SQLite
- **التعريف**: قاعدة بيانات خفيفة الوزن (حرفياً "قاعدة بيانات في ملف")
- **الاستخدام**: سريعة، سهلة الاستخدام، ولا تحتاج خادم منفصل
- **التشبيه**: مثل دفتر ملاحظات ذكي يحفظ البيانات فيه
- **المثال**:
```sql
CREATE TABLE plants (id INTEGER, name TEXT);
INSERT INTO plants (name) VALUES ('الأراك');
SELECT * FROM plants;
```

#### 4. JWT (JSON Web Token)
- **التعريف**: نظام للمصادقة الآمنة
- **الاستخدام**: لحماية حسابات المستخدمين
- **التشبيه**: مثل بطاقة الدخول - تثبت هويتك دون إظهار بياناتك الحساسة
- **كيف يعمل**:
  1. المستخدم يسجل دخول
  2. الخادم يصدر token
  3. المستخدم يستخدم الـ token في الطلبات التالية
  4. الخادم يتحقق من الـ token قبل السماح

#### 5. bcryptjs
- **التعريف**: نظام لتشفير كلمات المرور
- **الاستخدام**: لحماية كلمات المرور في قاعدة البيانات
- **التشبيه**: مثل صندوق آمن - يحفظ كلمة المرور بشكل مشفر لا يمكن فك تشفيره
- **كيف يعمل**:
  - "كلمة_المرور" → "a$2b$10$N9qo8..."
  - حتى لو تم الوصول لقاعدة البيانات، لا يمكن معرفة كلمة المرور الأصلية

### الجزء الثاني: تطبيق الجوال (Mobile App)

#### 1. Flutter
- **التعريف**: إطار عمل من Google لبناء تطبيقات الجوال
- **الاستخدام**: كود واحد يعمل على Android و iOS
- **التشبيه**: مثل قالب واحد لجميع الأحجام
- **اللغة**: Dart
- **المزايا**:
  - ✅ واجهة مستخدم جميلة
  - ✅ أداء عالي
  - ✅ تطوير سريع

#### 2. Dart
- **التعريف**: لغة البرمجة المستخدمة مع Flutter
- **الاستخدام**: سهلة التعلم، قوية، مناسبة للتطبيقات
- **مثال بسيط**:
```dart
void main() {
    String name = 'شمالنا خضراء';
    print('مرحباً في $name');
}
```

#### 3. Provider (إدارة الحالة)
- **التعريف**: نظام لإدارة حالة التطبيق (State Management)
- **الاستخدام**: لمشاركة البيانات بين أجزاء التطبيق
- **التشبيه**: مثل صندوق رسائل مشترك - أي جزء يريد معلومات، يأخذها من الصندوق
- **كيف يعمل**:
```dart
// جميع الشاشات تستمع لنفس Provider
Provider.of<AuthProvider>(context).user
```

---

## 📁 3. البنية العامة للمشروع

```
shmalna_khedra/
│
├── 📁 backend/                          # الواجهة الخلفية (Node.js)
│   ├── 📄 server.js                     # الملف الرئيسي للخادم ⭐
│   ├── 📄 database.js                   # قاعدة البيانات ⭐
│   ├── 📄 package.json                  # الاعتماديات
│   ├── 📁 uploads/                      # مجلد الصور
│   │   ├── README.md                    # تعليمات الصور
│   │   └── .gitkeep                     # ملف فارغ للحفاظ على المجلد
│   ├── 📄 shmalna_khedra.db            # قاعدة البيانات (SQLite)
│   └── 📄 plants_data.json              # بيانات النباتات (JSON)
│
├── 📁 mobile_app/                       # تطبيق الجوال (Flutter)
│   ├── 📁 lib/                          # الكود الرئيسي ⭐⭐⭐
│   │   ├── 📄 main.dart                # نقطة البداية ⭐
│   │   │
│   │   ├── 📁 models/                   # نماذج البيانات
│   │   │   ├── plant.dart              # نموذج النبات ⭐
│   │   │   ├── user.dart               # نموذج المستخدم
│   │   │   └── community_pin.dart       # نموذج الموقع المجتمعي ⭐
│   │   │
│   │   ├── 📁 providers/                # إدارة الحالة
│   │   │   ├── auth_provider.dart      # إدارة المصادقة ⭐
│   │   │   └── plant_provider.dart      # إدارة النباتات ⭐
│   │   │
│   │   ├── 📁 screens/                  # الشاشات
│   │   │   ├── splash_screen.dart      # شاشة الافتتاح
│   │   │   ├── auth/                   # شاشات المصادقة
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── home_screen.dart         # الشاشة الرئيسية ⭐
│   │   │   ├── map_screen.dart          # الخريطة ⭐
│   │   │   ├── camera_screen.dart       # الكاميرا ⭐
│   │   │   ├── profile_screen.dart      # الملف الشخصي
│   │   │   ├── plant_detail_screen.dart # تفاصيل النبات ⭐
│   │   │   └── settings_screen.dart    # الإعدادات
│   │   │
│   │   ├── 📁 services/                 # الخدمات
│   │   │   ├── api_service.dart         # التواصل مع API ⭐
│   │   │   └── auth_service.dart        # خدمة المصادقة ⭐
│   │   │
│   │   ├── 📁 utils/                    # الأدوات
│   │   │   ├── app_colors.dart          # الألوان
│   │   │   └── app_theme.dart           # الثيم
│   │   │
│   │   └── 📁 widgets/                  # المكونات
│   │       ├── plant_card.dart          # بطاقة النبات
│   │       ├── search_bar.dart          # شريط البحث
│   │       └── filter_chips.dart        # الفلاتر
│   │
│   ├── 📁 android/                      # إعدادات Android
│   │   └── app/src/main/
│   │       └── AndroidManifest.xml      # الأذونات ⭐
│   │
│   ├── 📁 assets/                       # الموارد
│   │   ├── images/                     # الصور
│   │   ├── animations/                 # الأنيميشن
│   │   └── fonts/                      # الخطوط
│   │
│   └── 📄 pubspec.yaml                  # اعتماديات Flutter
│
└── 📄 README.md                         # هذا الملف
```

---

## ⚙️ 4. شرح الواجهة الخلفية (Backend)

### 4.1 الملف: server.js - قلب النظام

هذا الملف هو "الخادم" (Server) - مثل الموظف الذي يعمل في مكتب الاستقبال.

```javascript
// 1. الاستيراد
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');

// 2. إنشاء التطبيق
const app = express();
const PORT = 3000;

// 3. الإعدادات
app.use(cors());           // السماح بالوصول من أي مكان
app.use(express.json());   // تحليل بيانات JSON
app.use('/uploads', express.static('uploads')); // خدمة الصور

// 4. تشغيل الخادم
app.listen(PORT, () => {
    console.log(`🚀 الخادم يعمل على المنفذ ${PORT}`);
});
```

**ما معنى كل سطر؟**

1. **`require('express')`**: "استورد مكتبة Express"
2. **`app = express()`**: "أنشئ تطبيق جديد"
3. **`PORT = 3000`**: "رقم الباب = 3000" (مثل رقم شقة)
4. **`app.use(cors())`**: "اسمح للجميع بالاتصال"
5. **`app.listen()`**: "ابدأ الاستماع للطلبات"

### 4.2 نقاط النهاية (API Endpoints)

#### مثال 1: جلب جميع النباتات

```javascript
app.get('/api/plants', (req, res) => {
    db.getAllPlants((err, plants) => {
        if (err) {
            return res.status(500).json({ error: 'خطأ في الخادم' });
        }
        res.json(plants);
    });
});
```

**المشابه له**: مثل الطاولة رقم 1 في المطعم - الطلب: "أريد قائمة النباتات"

**ما يحدث**:
1. العميل يطلب: `GET /api/plants`
2. الخادم يبحث في قاعدة البيانات
3. الخادم يجد جميع النباتات
4. الخادم يرسل القائمة للعميل

#### مثال 2: تسجيل دخول المستخدم

```javascript
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    
    // 1. البحث عن المستخدم
    const user = await db.getUserByEmail(email);
    
    // 2. التحقق من كلمة المرور
    const isValid = await bcrypt.compare(password, user.password);
    
    if (isValid) {
        // 3. إنشاء token
        const token = jwt.sign({ userId: user.id }, SECRET_KEY);
        
        // 4. إرسال Token
        res.json({ token, user });
    } else {
        res.status(401).json({ error: 'كلمة المرور خاطئة' });
    }
});
```

**الخطوات بالتفصيل**:

1. **`req.body`**: البيانات المرسلة (البريد وكلمة المرور)
2. **`db.getUserByEmail`**: البحث عن المستخدم في قاعدة البيانات
3. **`bcrypt.compare`**: مقارنة كلمة المرور المدخلة بالمسفوظة
4. **`jwt.sign`**: إنشاء "تذكرة دخول" آمنة
5. **`res.json`**: إرسال النتيجة

### 4.3 نظام المصادقة (JWT)

#### كيف يعمل؟

```javascript
// 1. المستخدم يسجل دخول
POST /api/login
{
    "email": "ahmed@example.com",
    "password": "123456"
}

// 2. الخادم يرجع Token
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": { "id": 1, "username": "أحمد" }
}

// 3. المستخدم يستخدم Token في الطلبات التالية
GET /api/plants
Headers: { "Authorization": "Bearer eyJhbG..." }

// 4. الخادم يتحقق من Token
const user = jwt.verify(token, SECRET_KEY);
// السماح بالوصول
```

**التشبيه البسيط**:
- مثل بطاقة العضوية في النادي
- عند الدخول يعطونك بطاقة
- في كل مرة تريد الدخول، تظهر البطاقة
- إذا انتهت صلاحيتها أو مزورة، لا يسمحون بدخولك

### 4.4 رفع الملفات (Multer)

```javascript
const multer = require('multer');

// إعداد حفظ الصور
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');  // حفظ في مجلد uploads
    },
    filename: (req, file, cb) => {
        // تسمية الملف: image-1234567890-123456789.jpg
        const uniqueName = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueName + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });
```

**الشرح**:
- **`diskStorage`**: حفظ على القرص الصلب
- **`destination`**: المجلد المحدد للحفظ
- **`filename`**: اسم فريد لكل صورة

**ما يحدث عند رفع صورة**:
1. المستخدم يختار صورة
2. التطبيق يرسلها للخادم
3. الخادم يحفظها في `uploads/`
4. الخادم يرجع اسم الملف
5. التطبيق يحفظ الاسم في قاعدة البيانات

### 4.5 قاعدة البيانات (database.js)

```javascript
class Database {
    constructor() {
        this.db = new sqlite3.Database('shmalna_khedra.db', (err) => {
            if (err) {
                console.error('خطأ:', err);
            } else {
                console.log('✅ تم الاتصال بقاعدة البيانات');
                this.init();  // إنشاء الجداول
            }
        });
    }
    
    init() {
        // إنشاء جدول النباتات
        this.db.run(`
            CREATE TABLE IF NOT EXISTS plants (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                scientific_name TEXT NOT NULL,
                image_url TEXT,
                ...
            )
        `);
        
        // إنشاء جدول المواقع المجتمعية
        this.db.run(`
            CREATE TABLE IF NOT EXISTS community_pins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                plant_name TEXT NOT NULL,
                lat REAL NOT NULL,
                lng REAL NOT NULL,
                username TEXT NOT NULL,
                image_path TEXT NOT NULL,
                comment TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `);
        
        // إدراج البيانات الافتراضية
        this.insertDefaultPins();
    }
    
    // إدراج دبابيس افتراضية مع صور حقيقية من training data
    insertDefaultPins() {
        const fs = require('fs');
        const path = require('path');
        
        // الحصول على أول صورة من كل مجلد تدريب
        const trainPath = path.join(__dirname, 'ml', 'data', 'train');
        const plantFolders = fs.readdirSync(trainPath);
        
        plantFolders.forEach((plantName) => {
            const plantPath = path.join(trainPath, plantName);
            const images = fs.readdirSync(plantPath)
                .filter(f => /\.(jpg|jpeg|png)$/i.test(f));
            
            if (images.length > 0) {
                const firstImage = images[0];
                const sourcePath = path.join(plantPath, firstImage);
                const destPath = path.join(__dirname, 'uploads', `${plantName}_${firstImage}`);
                
                // نسخ الصورة إلى uploads
                fs.copyFileSync(sourcePath, destPath);
                
                // إدراج دبوس افتراضي
                this.db.run(`
                    INSERT INTO community_pins 
                    (plant_name, lat, lng, username, image_path, comment)
                    VALUES (?, ?, ?, ?, ?, ?)
                `, [
                    plantName,
                    this._randomLatInArar(),  // إحداثيات عشوائية في عرعر
                    this._randomLngInArar(),
                    this._randomUsername(),   // اسم مستخدم افتراضي
                    path.basename(destPath),
                    this._randomComment(),    // تعليق افتراضي
                ]);
            }
        });
    }
    
    getAllPlants(callback) {
        // إرجاع النباتات مع image_url
        this.db.all(`
            SELECT p.*, 
                   '/api/plants/' || p.id || '/image' as image_url
            FROM plants p
        `, callback);
    }
}
```

**الشرح بالتفصيل**:
- **`class Database`**: قالب (مثل القالب في الخبازة)
- **`constructor`**: يعمل تلقائياً عند إنشاء الكائن
- **`this.db`**: اتصال قاعدة البيانات
- **`CREATE TABLE IF NOT EXISTS`**: "أنشئ الجدول إن لم يكن موجوداً"
- **`SELECT * FROM plants`**: "أعطني كل البيانات من جدول النباتات"
- **`insertDefaultPins()`**: ينشئ دبابيس افتراضية مع صور حقيقية من training data
- **`getFirstImageFromTrainFolder()`**: يحصل على أول صورة من مجلد التدريب
- **`copyImageToUploads()`**: ينسخ الصورة إلى مجلد uploads للعرض

---

## 📱 5. شرح تطبيق الجوال (Mobile App)

### 5.1 الملف: main.dart

```dart
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // تفعيل RTL لكامل التطبيق
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // تهيئة
    final prefs = await SharedPreferences.getInstance();
    
    // تشغيل التطبيق
    runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [...],
            child: Directionality(
                textDirection: TextDirection.rtl, // RTL كامل
                child: MaterialApp(...),
            ),
        );
    }
}
```

**خطوة بخطوة**:
1. **`WidgetsFlutterBinding`**: إعداد Flutter (مثل تشغيل السيارة)
2. **`SystemChrome.setPreferredOrientations`**: وضع شاشة عمودي فقط
3. **`SharedPreferences`**: فتح صندوق الحفظ المحلي
4. **`Directionality`**: تفعيل RTL لكامل التطبيق بدون استثناء
5. **`runApp`**: تشغيل التطبيق

**ملاحظة مهمة**: جميع حقول الإدخال (البريد، كلمة المرور، التعليقات) تستخدم `textDirection: TextDirection.rtl` لضمان RTL كامل.

### 5.2 Provider Pattern

```dart
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (_) => AuthProvider()),
                ChangeNotifierProvider(create: (_) => PlantProvider()),
            ],
            child: MaterialApp(...),
        );
    }
}
```

**ما هو Provider؟**
- مثل صندوق اتصال مركزي
- أي جزء يريد بيانات، يطلبها من Provider
- مثل برج تحكم في المطار

**مثال الاستخدام**:
```dart
// في أي شاشة
final user = Provider.of<AuthProvider>(context).user;
// الآن لديك بيانات المستخدم
```

### 5.3 النماذج (Models)

```dart
class Plant {
    final int id;
    final String name;
    final String scientificName;
    
    Plant({
        required this.id,
        required this.name,
        required this.scientificName,
    });
    
    // تحويل من JSON
    factory Plant.fromJson(Map<String, dynamic> json) {
        return Plant(
            id: json['id'] ?? 0,
            name: json['name'] ?? '',
            scientificName: json['scientific_name'] ?? '',
        );
    }
    
    // تحويل إلى JSON
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'name': name,
            'scientific_name': scientificName,
        };
    }
}
```

**شرح الكود**:
- **`class Plant`**: تعريف للبيانات (مثل نموذج بيانات)
- **`final`**: ثابت لا يتغير بعد الإنشاء
- **`factory fromJson`**: طريقة لتحويل البيانات من الخادم
- **`toJson`**: تحويل البيانات لإرسالها للخادم

### 5.4 Providers - إدارة الحالة

#### AuthProvider - إدارة المصادقة

```dart
class AuthProvider with ChangeNotifier {
    User? _user;
    String? _token;
    
    User? get user => _user;
    String? get token => _token;
    bool get isAuthenticated => _user != null && _token != null;
    
    Future<bool> login(String email, String password) async {
        final response = await _authService.login(email, password);
        
        if (response['token'] != null) {
            _token = response['token'];
            _user = User.fromJson(response['user']);
            
            // إخطار جميع المستمعين بالتغيير
            notifyListeners();
            return true;
        }
        return false;
    }
}
```

**ما يحدث**:
- **`with ChangeNotifier`**: يجعل هذا الكلاس قابلاً للإشعار
- **`_user`**: المستخدم الحالي (private)
- **`_token`**: توكن المصادقة (private)
- **`notifyListeners()`**: "اخبر الجميع بأن البيانات تغيرت"

#### PlantProvider - إدارة النباتات

```dart
class PlantProvider with ChangeNotifier {
    List<Plant> _plants = [];
    bool _isLoading = false;
    
    List<Plant> get plants => _plants;
    bool get isLoading => _isLoading;
    
    Future<void> loadPlants() async {
        _isLoading = true;
        notifyListeners();
        
        try {
            _plants = await _apiService.getPlants();
        } catch (e) {
            print('خطأ: $e');
        } finally {
            _isLoading = false;
            notifyListeners();
        }
    }
}
```

### 5.5 الشاشات (Screens)

#### مثال 1: HomeScreen

```dart
class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
    
    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Column(
                children: [
                    // الشعاران جنباً إلى جنب
                    Row(
                        children: [
                            // الشعار الأول (بالحجم الكامل)
                            Container(
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                    'assets/images/Logo.jpeg',
                                    fit: BoxFit.contain, // عرض كامل بدون قص
                                ),
                            ),
                            SizedBox(width: 8),
                            // الشعار الثاني
                            Container(
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                    'assets/images/Logo2.jpeg',
                                    fit: BoxFit.contain,
                                ),
                            ),
                        ],
                    ),
                    SearchBar(),
                    FilterChips(),
                    PlantGrid(), // يعرض صور حقيقية من training data
                ],
            ),
        );
    }
}
```

**المصطلحات**:
- **`StatefulWidget`**: عنصر قابل للتغيير (مثل صفحة بها مؤقت)
- **`StatelessWidget`**: عنصر ثابت (مثل ملصق على الحائط)
- **`Scaffold`**: الهيكل الأساسي للشاشة (مثل الجدران والأرضية)
- **`Column`**: عمودية - العناصر فوق بعض
- **`Row`**: أفقية - العناصر بجانب بعض
- **`BoxFit.contain`**: عرض الصورة بالكامل بدون قص
- **`BoxFit.cover`**: ملء الحاوية مع قص الأجزاء الزائدة

**ملاحظات مهمة**:
- الشعاران (`Logo.jpeg` و `Logo2.jpeg`) يعرضان جنباً إلى جنب في جميع الشاشات
- الشعار الأول يعرض بالحجم الكامل (`BoxFit.contain`)
- النباتات تعرض صوراً حقيقية من مجلدات التدريب (`backend/ml/data/train/`)

#### مثال 2: MapScreen

```dart
class MapScreen extends StatefulWidget {
    @override
    State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
    final MapController _mapController = MapController();
    final List<Marker> _markers = [];
    final List<CircleMarker> _circles = [];
    final LatLng _center = const LatLng(30.9753, 41.0381); // عرعر
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 13.0,
                    minZoom: 11.0,
                    maxZoom: 18.0,
                ),
                children: [
                    TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    CircleLayer(circles: _circles),
                    MarkerLayer(markers: _markers),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(...CameraScreen()),
                child: Icon(Icons.add),
            ),
        );
    }
}
```

**الشرح**:
- **`FlutterMap`**: بديل عن Google Maps، يستخدم OpenStreetMap المجاني
- **`TileLayer`**: طبقة الخريطة من OpenStreetMap
- **`CircleLayer`**: طبقة الدوائر الخضراء
- **`MarkerLayer`**: طبقة الدبابيس مع الصور
- **`FloatingActionButton`**: زر لإضافة موقع جديد

### 5.6 الخدمات (Services)

#### ApiService - التواصل مع الخادم

```dart
class ApiService {
    final String baseUrl = 'http://10.0.2.2:3000';  // لجهاز محاكي Android
    // للجهاز الحقيقي: 'http://YOUR_IP:3000'
    
    // جلب جميع النباتات مع صورها
    Future<List<Plant>> getPlants() async {
        final response = await http.get(Uri.parse('$baseUrl/api/plants'));
        
        if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            return data.map((json) => Plant.fromJson(json)).toList();
        } else {
            throw Exception('فشل في جلب البيانات');
        }
    }
    
    // التعرف على النبات بالذكاء الاصطناعي
    Future<Map<String, dynamic>> recognizePlant(XFile image) async {
        final request = http.MultipartRequest(
            'POST',
            Uri.parse('$baseUrl/api/plants/recognize'),
        );
        
        request.files.add(
            await http.MultipartFile.fromPath('image', image.path),
        );
        
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        
        if (response.statusCode == 200) {
            return jsonDecode(response.body);
        } else {
            throw Exception('لم يتم التعرف على النبات');
        }
    }
    
    // إضافة موقع للمجتمع
    Future<void> addCommunityPin({
        required String token,
        required String plantName,
        required double lat,
        required double lng,
        required String imagePath,
        required String comment,
    }) async {
        final request = http.MultipartRequest(
            'POST',
            Uri.parse('$baseUrl/api/community/add'),
        );
        
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(
            await http.MultipartFile.fromPath('image', imagePath),
        );
        request.fields['plantName'] = plantName;
        request.fields['lat'] = lat.toString();
        request.fields['lng'] = lng.toString();
        request.fields['comment'] = comment;
        
        final response = await request.send();
        if (response.statusCode != 200) {
            throw Exception('فشل في النشر');
        }
    }
}
```

**الشرح**:
- **`http.get`**: إرسال طلب GET
- **`http.MultipartRequest`**: إرسال ملفات (صور)
- **`response.statusCode`**: رمز الحالة (200 = نجح)
- **`jsonDecode`**: تحويل JSON إلى Dart objects
- **`fromJson`**: تحويل البيانات إلى كائن Plant
- **`MultipartFile.fromPath`**: تحويل ملف إلى بيانات يمكن إرسالها

---

## 🗺️ 6. نظام الخريطة التفاعلية

### 6.1 كيف تعمل الخريطة؟

التطبيق يستخدم **OpenStreetMap** (مكتبة `flutter_map`) لعرض خريطة مدينة عرعر فقط مع دبابيس تفاعلية تمثل مواقع النباتات التي نشرها المستخدمون.

```dart
// 1. إنشاء العلامات مع الصور
void _updateMarkers(List<CommunityPin> pins) {
    _markers.clear();
    _circles.clear();
    
    for (CommunityPin pin in pins) {
        // إضافة دائرة خضراء حول الموقع (100 متر)
        _circles.add(CircleMarker(
            point: LatLng(pin.lat, pin.lng),
            radius: 100,
            color: AppColors.primaryGreen.withOpacity(0.15),
            borderColor: AppColors.primaryGreen.withOpacity(0.8),
            borderStrokeWidth: 3,
            useRadiusInMeter: true,
        ));
        
        // إضافة علامة دائرية مع صورة النبات
        _markers.add(Marker(
            point: LatLng(pin.lat, pin.lng),
            width: 80,
            height: 80,
            child: GestureDetector(
                onTap: () => _showPinDetails(pin),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: ClipOval(
                        child: Image.network(
                            'http://10.0.2.2:3000/uploads/${pin.imagePath}',
                            fit: BoxFit.cover,
                        ),
                    ),
                ),
            ),
        ));
    }
}
```

**المكونات**:

1. **FlutterMap (الخريطة)**:
   - مكتبة `flutter_map` لعرض OpenStreetMap
   - مركزة على مدينة عرعر فقط (30.9753, 41.0381)
   - حدود محددة لمنع التمرير خارج المدينة

2. **CircleMarkers (الدوائر)**:
   - دائرة خضراء نصف شفافة حول كل موقع
   - نصف القطر: 100 متر
   - تشير للمنطقة التي فيها النبات

3. **Markers (العلامات)**:
   - دبابيس دائرية مع صور النباتات
   - كل دبوس يعرض صورة النبات المنشور
   - عند الضغط تظهر تفاصيل كاملة

4. **Bottom Sheet (النافذة السفلية)**:
   - تفتح عند الضغط على أي دبوس
   - تعرض: صورة النبات، التعليق، اسم الناشر، اسم النبات
   - زر للانتقال لصفحة التفاصيل الكاملة

### 6.2 عند الضغط على موقع

```dart
void _showPinDetails(CommunityPin pin) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            child: Column(
                children: [
                    Image.network('...'),      // صورة
                    Text(pin.plantName),       // الاسم
                    Text(pin.username),        // الناشر
                    ElevatedButton(
                        onPressed: () {
                            // الانتقال لصفحة التفاصيل
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlantDetailScreen(...),
                                ),
                            );
                        },
                    ),
                ],
            ),
        ),
    );
}
```

**ما يحدث**:
1. المستخدم يضغط على العلامة
2. تفتح نافذة من الأسفل (Bottom Sheet)
3. تعرض: صورة، اسم، ناشر، إحداثيات
4. زر للانتقال للتفاصيل الكاملة

### 6.3 حفظ الموقع ونشره للمجتمع

```dart
Future<void> _publishToCommunity(
    BuildContext context,
    XFile image,
    Plant plant,
    String comment,
) async {
    // 1. الحصول على الموقع الحالي
    final position = await Geolocator.getCurrentPosition();
    
    // 2. إرسال للخادم مع التعليق والصورة
    await plantProvider.addCommunityPin(
        token: authProvider.token!,
        plantName: plant.name,
        lat: position.latitude,
        lng: position.longitude,
        imagePath: image.path,
        comment: comment, // التعليق الذي كتبه المستخدم
    );
}
```

**الخطوات بالتفصيل**:

1. **التعرف على النبات بالذكاء الاصطناعي**:
```dart
// في camera_screen.dart
final result = await apiService.recognizePlant(image);
// النتيجة: { "plant_name": "السدر", "confidence": 0.85 }
```

2. **عرض النتيجة للمستخدم**:
```dart
showDialog(
    builder: (context) => AlertDialog(
        title: Text('تم التعرف على: ${result.plantName}'),
        content: Text('الثقة: ${result.confidence * 100}%'),
        actions: [
            ElevatedButton(
                onPressed: () => _showPublishOptions(image, plant),
                child: Text('نشر للمجتمع'),
            ),
        ],
    ),
);
```

3. **نافذة النشر**:
```dart
void _showPublishOptions(XFile image, Plant plant) {
    final commentController = TextEditingController();
    
    showDialog(
        builder: (context) => AlertDialog(
            title: Text('نشر للمجتمع'),
            content: Column(
                children: [
                    Image.file(File(image.path)),
                    TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                            labelText: 'تعليق (اختياري)',
                        ),
                        textDirection: TextDirection.rtl,
                    ),
                ],
            ),
            actions: [
                ElevatedButton(
                    onPressed: () async {
                        await _publishToCommunity(
                            context,
                            image,
                            plant,
                            commentController.text,
                        );
                    },
                    child: Text('نشر'),
                ),
            ],
        ),
    );
}
```

4. **إرسال للخادم**:
```dart
// في api_service.dart
Future<void> addCommunityPin({
    required String token,
    required String plantName,
    required double lat,
    required double lng,
    required String imagePath,
    required String comment,
}) async {
    final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/community/add'),
    );
    
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
    );
    request.fields['plantName'] = plantName;
    request.fields['lat'] = lat.toString();
    request.fields['lng'] = lng.toString();
    request.fields['comment'] = comment;
    
    await request.send();
}
```

5. **عرض على الخريطة فوراً**:
```dart
// بعد النشر، يتم تحديث الخريطة تلقائياً
await plantProvider.loadCommunityPins();
// الخريطة تعرض الدبوس الجديد فوراً
```

---

## 🎓 7. كيفية تدريب نموذج الذكاء الاصطناعي

### 7.1 نظرة عامة

المشروع يحتوي على نظام كامل لتدريب نموذج التعرف على النباتات باستخدام TensorFlow و MobileNetV2. النظام يقرأ النباتات من `plants_data.json` تلقائياً.

### 7.2 المتطلبات

قبل البدء، تأكد من تثبيت:
- Python 3.8 أو أحدث
- pip (مدير الحزم)

### 7.3 خطوات التدريب التفصيلية

#### الخطوة 1: تثبيت المكتبات المطلوبة

```bash
# الانتقال لمجلد ML
cd backend/ml
 إعداد بيانات التدريب
==================================================
📁 قراءة النباتات من JSON...
✅ تم العثور على 12 نبات

🗑️ حذف المجلدات القديمة...
   ✅ حذف: data/train\الطلح

📁 إنشاء المجلدات الجديدة...
   ✅ data/train\الجراز
   ✅ data/train\القصيص (الرقروق, الإرقة، الإجرد، الهشمة)
   ✅ data/train\البسباس
   ✅ data/train\الشقارى
   ✅ data/train\الصفار
   ✅ data/train\الفقاحسيلين العربية (ابودهينة)
   ✅ data/train\النقد
   ✅ data/train\الحزاء أو الحزز
   ✅ data/train\الخردل البري
   ✅ data/train\القرطية
   ✅ data/train\السدر
   ✅ data/train\الطلح

📝 دليل استخدام:
1. ضع صور كل نبات في المجلد المناسب:
   data/train/الجراز/
   data/train/القصيص (الرقروق, الإرقة، الإجرد، الهشمة)/
   data/train/البسباس/
   data/train/الشقارى/
   data/train/الصفار/
   ... و 7 نبات آخر

2. تأكد من وجود ملفات صور في كل مجلد
3. شغل سكريبت التدريب: python train_model.py

🔍 فحص الصور الموجودة...
   الجراز: 25 صورة
   القصيص (الرقروق, الإرقة، الإجرد، الهشمة): 0 صورة
   البسباس: 0 صورة
   الشقارى: 0 صورة
   الصفار: 0 صورة
   الفقاحسيلين العربية (ابودهينة): 0 صورة
   النقد: 0 صورة
   الحزاء أو الحزز: 0 صورة
   الخردل البري: 0 صورة
   القرطية: 0 صورة
   السدر: 40 صورة
   الطلح: 0 صورة

💡 نصيحة: تحتاج 50-100 صورة على الأقل لكل نبات للتدريب الجيد
PS C:\Users\TRSI\VSCode\Projects\flutterprojects\shmalna_khedra\backend\ml>
# تثبيت المكتبات
pip install -r requirements.txt
```

**المكتبات المطلوبة:**
- TensorFlow
- Keras
- NumPy
- PIL (Pillow)
- scikit-learn
- Flask (لخدمة API)

#### الخطوة 2: إعداد بنية البيانات

```bash
# تشغيل سكريبت الإعداد
python setup_data.py
```

**ماذا يفعل هذا السكريبت؟**
1. ✅ يقرأ جميع النباتات من `backend/plants_data.json`
2. ✅ يحذف المجلدات القديمة (إن وجدت)
3. ✅ ينشئ مجلدات جديدة بأسماء النباتات تلقائياً:
   ```
   backend/ml/data/train/
   ├── الجراز/
   ├── القصيص (الرقروق, الإرقة، الإجرد، الهشمة)/
   ├── البسباس/
   ├── الشقارى/
   ├── الصفار/
   ├── الفقاحسيلين العربية (ابودهينة)/
   ├── النقد/
   ├── الحزاء أو الحزز/
   ├── الخردل البري/
   └── القرطية/
   ```

#### الخطوة 3: جمع الصور للتدريب

**عدد الصور المطلوب:**
- **الحد الأدنى**: 50-100 صورة لكل نبات
- **لنتائج ممتازة**: 200+ صورة لكل نبات

**نصائح لجمع الصور:**
1. **زوايا متنوعة**: من أعلى، من الجانب، من الأسفل
2. **أجزاء مختلفة**: الأوراق، الأزهار، الجذع، الثمر
3. **ظروف إضاءة مختلفة**: صباح، ظهر، مساء
4. **مواسم مختلفة**: ربيع، صيف، خريف، شتاء
5. **مراحل نمو**: شتلة، نبتة صغيرة، نبتة ناضجة

**طريقة إضافة الصور:**
```bash
# مثال: إضافة صور للجراز
backend/ml/data/train/الجراز/
├── image1.jpg
├── image2.jpg
├── image3.jpg
└── ...
```

**ملاحظات مهمة:**
- ✅ استخدم صور بجودة عالية (بدون ضباب)
- ✅ تجنب الصور المكررة تماماً
- ✅ تأكد من أن الصورة تعرض النبات بوضوح
- ✅ الصور المقبولة: `.jpg`, `.jpeg`, `.png`

#### الخطوة 4: تدريب النموذج

```bash
# تشغيل سكريبت التدريب
python train_model.py
```

**ماذا يحدث أثناء التدريب؟**

1. **تحميل الصور**: يقرأ جميع الصور من المجلدات
2. **معالجة الصور**:
   - تغيير الحجم لـ 224x224 بكسل
   - تطبيق تحسينات (Rotation, Flip, Zoom)
   - تقسيم البيانات: 80% تدريب، 20% اختبار
3. **بناء النموذج**:
   - استخدام MobileNetV2 كـ base model
   - إضافة طبقات للتصنيف
4. **التدريب**:
   - 50 دورة تدريب (epochs)
   - في كل دورة يتعلم من الأخطاء
   - حفظ أفضل نسخة عند تحسين الدقة
5. **الحفظ**:
   - النموذج: `models/plant_recognition_model.h5`
   - الفئات: `models/plant_classes.json`

**مدة التدريب:**
- **مع 50 صورة لكل نبات**: 15-30 دقيقة
- **مع 200+ صورة لكل نبات**: 30-60 دقيقة
- يعتمد على مواصفات جهازك

**ما ستراه أثناء التدريب:**
```
🚀 بدء التدريب...
🔍 فحص البيانات...
✅ تم العثور على 10 فئة:
   - الجراز
   - القصيص (الرقروق, الإرقة، الإجرد، الهشمة)
   ...

📊 معلومات التدريب:
   - عدد الفئات: 10
   - حجم الصورة: 224x224
   - حجم الدفعة: 32
   - عدد الدورات: 50

🏋️ بدء التدريب...
Epoch 1/50
[==========] - 15s 45ms/step - loss: 2.3456 - accuracy: 0.2345 - val_accuracy: 0.3456
Epoch 2/50
...
✅ تم الانتهاء من التدريب!
   - أفضل دقة: 92.34%
   - النموذج محفوظ في: models/
```

#### الخطوة 5: تشغيل خدمة التعرف

```bash
# تشغيل خدمة Flask API
python app.py
```

**الخدمة ستعمل على:**
- `http://localhost:5000`
- ستحصل على رسالة: `🌱 خدمة التعرف على النباتات تعمل على المنفذ 5000`

#### الخطوة 6: ربط Backend بخدمة ML

في ملف `backend/server.js` أو `backend/.env`:

```bash
# Linux/Mac
export ML_SERVICE_URL=http://localhost:5000

# Windows (CMD)
set ML_SERVICE_URL=http://localhost:5000

# Windows (PowerShell)
$env:ML_SERVICE_URL="http://localhost:5000"
```

#### الخطوة 7: اختبار النظام

**اختبار مباشر من Terminal:**
```bash
curl -X POST http://localhost:5000/recognize \
  -F "image=@path/to/plant_image.jpg"
```

**النتيجة المتوقعة:**
```json
{
  "predictions": [
    {
      "plant_name": "الجراز",
      "confidence": 0.95
    },
    {
      "plant_name": "البسباس",
      "confidence": 0.03
    },
    {
      "plant_name": "القرطية",
      "confidence": 0.02
    }
  ]
}
```

**اختبار من Node.js:**
```bash
curl -X POST http://localhost:3000/api/plants/recognize \
  -F "image=@path/to/plant_image.jpg"
```

### 7.4 تحسين النموذج

#### إضافة نباتات جديدة

1. **أضف النبات في JSON:**
   - افتح `backend/plants_data.json`
   - أضف كائن جديد للنبات:
   ```json
   {
     "الرقم": 11,
     "الاسم_الشائع_الرئيسي": "اسم_النبات_الجديد",
     ...
   }
   ```

2. **إنشاء مجلد للصور:**
   ```bash
   python setup_data.py
   ```
   سيُنشئ المجلد تلقائياً

3. **أضف الصور:**
   - ضع 50-100 صورة في المجلد الجديد

4. **أعد التدريب:**
   ```bash
   python train_model.py
   ```

#### تحسين الدقة

**إذا كانت الدقة منخفضة (< 70%):**
- ✅ زود عدد الصور لكل نبات (100+ صورة)
- ✅ استخدم صور أكثر تنوعاً
- ✅ تأكد من جودة الصور (واضحة، بدون ضباب)
- ✅ زود عدد epochs في `train_model.py` (من 50 إلى 100)

**في ملف `train_model.py`:**
```python
EPOCHS = 100  # بدلاً من 50
```

### 7.5 استكشاف الأخطاء

#### الخطأ: "مجلد البيانات غير موجود"
```bash
# الحل: شغل setup_data.py أولاً
python setup_data.py
```

#### الخطأ: "لم يتم العثور على صور"
- تأكد من وجود صور في المجلدات
- الصور يجب أن تكون `.jpg`, `.jpeg`, أو `.png`
- تأكد من أن كل مجلد يحتوي على 10+ صور على الأقل

#### الخطأ: "خدمة التعرف غير متاحة"
- تأكد من تشغيل `python app.py`
- تحقق من أن المنفذ 5000 متاح
- تأكد من متغير `ML_SERVICE_URL` في Node.js

#### الدقة منخفضة (< 60%)
- زود عدد الصور للتدريب
- استخدم صور أكثر تنوعاً
- تأكد من أن الصور واضحة
- أعد التدريب بعد إضافة المزيد من البيانات

### 7.6 معلومات تقنية عن النموذج

- **البنية**: MobileNetV2 (Transfer Learning)
- **حجم الصورة المدخل**: 224x224 بكسل
- **عدد الفئات**: يحدد تلقائياً من JSON
- **الدقة المتوقعة**: 85-95% مع بيانات كافية
- **المخرجات**: Top-3 predictions (أفضل 3 احتمالات)

### 7.7 استخدام النموذج في التطبيق

بعد تدريب النموذج وتشغيل خدمة ML، التطبيق سيكون قادراً على:

1. **التعرف التلقائي:**
   - المستخدم يلتقط صورة
   - التطبيق يرسلها لخدمة ML
   - الخدمة ترجع أفضل 3 احتمالات
   - التطبيق يعرض النتيجة للمستخدم

2. **التأكيد من المستخدم:**
   - المستخدم يرى النتيجة المقترحة
   - يمكنه التأكيد أو اختيار نبات آخر
   - يحفظ الموقع مع الصورة

---

**💡 نصيحة:** ابدأ بتدريب بسيط على 2-3 نباتات أولاً للاختبار، ثم أضف باقي النباتات تدريجياً.

---

## 💡 8. كيفية استخدام التطبيق

### 8.1 تسجيل حساب جديد

```
1. افتح التطبيق
2. اضغط "إنشاء حساب جديد"
3. أدخل:
   - اسم المستخدم
   - البريد الإلكتروني
   - كلمة المرور (6 أحرف على الأقل)
4. اضغط "إنشاء"
```

**ما يحدث في الخلفية**:

```javascript
// 1. التطبيق يرسل البيانات
POST /api/register
{
    "username": "أحمد",
    "email": "ahmed@example.com",
    "password": "123456"
}

// 2. الخادم يشفر كلمة المرور
"123456" → "$2a$10$N9qo8..."

// 3. الخادم يحفظ في قاعدة البيانات
INSERT INTO users (username, email, password) VALUES (...)

// 4. الخادم يصدر Token
const token = jwt.sign({ userId: 1 }, SECRET);

// 5. التطبيق يحفظ Token
SharedPreferences.setString('auth_token', token);
```

### 8.2 تسجيل الدخول (الذي يستمر حتى إعادة التشغيل)

```dart
// في auth_provider.dart
Future<void> _initializeAuth() async {
    // 1. جلب Token المحفوظ
    final token = await _authService.getToken();
    final userData = await _authService.getUserData();
    
    // 2. إذا موجود، سجل دخول تلقائي
    if (token != null && userData != null) {
        _token = token;
        _user = User.fromJson(userData);
    }
}
```

**في splash_screen.dart**:
```dart
void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // انتظار اكتمال تهيئة المصادقة
    while (authProvider.isLoading) {
        await Future.delayed(Duration(milliseconds: 100));
    }
    
    if (authProvider.isAuthenticated) {
        // المستخدم مسجل دخول → الرئيسية
        Navigator.pushReplacement(...MainNavigation());
    } else {
        // المستخدم غير مسجل → شاشة تسجيل دخول
        Navigator.pushReplacement(...LoginScreen());
    }
}
```

### 8.3 تصفح النباتات

```
1. في الشاشة الرئيسية
2. استخدم الفلاتر:
   - الكل
   - الأراك
   - الأرطى
   - ...إلخ
3. أو استخدم البحث للبحث بأي اسم
4. اضغط على أي نبتة للتفاصيل
```

### 8.4 إضافة موقع نبات

```
1. اضغط "الكاميرا" في القائمة السفلية
2. اضغط زر التقاط الصورة
3. سيطلب إذن الموقع → اضغط "سماح"
4. سيظهر:
   - أنيميشن المسح
   - إحداثيات الموقع
5. اختر نوع النبات
6. اضغط "إضافة للمجتمع"
```

**ما يحدث بالتفصيل**:

```dart
// 1. التحقق من إذن الموقع
bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
}

// 2. طلب الإذن
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
}

// 3. الحصول على الموقع
Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
);
// position.latitude = 30.9753
// position.longitude = 41.0381

// 4. التقاط الصورة
final image = await ImagePicker().pickImage(source: ImageSource.camera);

// 5. إرسال للخادم
final request = http.MultipartRequest('POST', Uri.parse('...'));
request.files.add(await MultipartFile.fromPath('image', image.path));
request.fields['plant_name'] = 'الأراك';
request.fields['lat'] = position.latitude.toString();
request.fields['lng'] = position.longitude.toString();
```

### 8.5 عرض الخريطة

```
1. اضغط "الخريطة"
2. شاهد:
   - الدوائر الخضراء حول المواقع
   - العلامات على الخريطة
   - موقعك الحالي (النقطة الزرقاء)
3. اضغط على أي علامة
4. ستفتح نافذة من الأسفل
5. اضغط "عرض تفاصيل النبتة" للتفاصيل الكاملة
```

---

## 📚 9. القاموس التقني

### مصطلحات الواجهة الخلفية

| المصطلح | المعنى بالعربي | الاستخدام |
|---------|---------------|-----------|
| **Server** | الخادم | الجهاز الذي يقدم الخدمة |
| **API** | واجهة برمجة التطبيقات | طريقة التواصل بين التطبيق والخادم |
| **Endpoint** | نقطة النهاية | عنوان URL لطلب معين |
| **Database** | قاعدة البيانات | مكان تخزين المعلومات |
| **Query** | استعلام | طلب بيانات |
| **Token** | التذكرة | رمز للمصادقة |
| **Middleware** | البرمجيات الوسيطة | كود يعمل قبل/بعد الطلب |
| **JSON** | تنسيق البيانات | طريقة لتبادل البيانات |

### مصطلحات تطبيق الجوال

| المصطلح | المعنى بالعربي | الاستخدام |
|---------|---------------|-----------|
| **Widget** | العنصر | أي شيء على الشاشة |
| **State** | الحالة | البيانات المتغيرة |
| **Provider** | المزود | نظام مشاركة البيانات |
| **Navigator** | المنقلة | الانتقال بين الشاشات |
| **async/await** | غير متزامن | للعمليات الطويلة |
| **Future** | المستقبل | قيمة ستأتي لاحقاً |
| **BuildContext** | سياق البناء | معلومات عن الشاشة الحالية |

### مصطلحات الذكاء الاصطناعي

| المصطلح | المعنى بالعربي | الاستخدام |
|---------|---------------|-----------|
| **AI** | الذكاء الاصطناعي | تعليم الحاسوب التفكير |
| **Model** | النموذج | المعادلة الرياضية |
| **Training** | التدريب | تعليم النموذج |
| **Accuracy** | الدقة | نسبة الصحة |
| **Dataset** | مجموعة البيانات | الصور والتسميات |
| **Neural Network** | الشبكة العصبية | مثل الدماغ |

---

## 🚀 10. إرشادات التطوير

### 10.1 تشغيل المشروع

```bash
# 1. الواجهة الخلفية
cd backend
npm install
npm start

# 2. تطبيق الجوال (في نافذة جديدة)
cd mobile_app
flutter pub get
flutter run
```

### 10.2 إضافة نبات جديد

```javascript
// في database.js
db.run(`
    INSERT INTO plants (name, scientific_name, ...)
    VALUES (?, ?, ...)
`, ['النبات الجديد', 'Scientific name', ...]);
```

### 10.3 إضافة صور

1. ضع الصورة في `backend/uploads/`
2. في database.js:
```javascript
image_path: 'uploads/plant_image.jpg'
```

### 10.4 تحسين الأداء

```dart
// استخدام Cache للصور
CachedNetworkImage(
    imageUrl: 'http://...',
    placeholder: CircularProgressIndicator(),
)
```

---

## 🎯 الخلاصة

### ما تعلمته:

- ✅ بناء API من الصفر
- ✅ التعامل مع قاعدة البيانات
- ✅ بناء تطبيق Flutter
- ✅ استخدام OpenStreetMap (flutter_map)
- ✅ نظام المصادقة والحفظ
- ✅ نظام الخرائط والدوائر والدبابيس التفاعلية
- ✅ نظام RTL الكامل بدون استثناء
- ✅ التعرف على النباتات بالذكاء الاصطناعي
- ✅ نظام النشر للمجتمع مع التعليقات
- ✅ عرض صور حقيقية من training data
- ✅ نظام الشعارين (Logo.jpeg و Logo2.jpeg)

### الخطوة التالية:

1. **طبّق**: اجربه على جهازك
2. **طوّر**: أضف ميزات جديدة
3. **شارك**: انشره في المجتمع
4. **تعلم**: ابحث عن المزيد

---

**تم التطوير من أجل حماية النباتات البرية في عرعر 🌱**

**المشروع**: تطبيق مجتمعي للتعرف على النباتات البرية  
**المنطقة**: عرعر، المملكة العربية السعودية  
**الهدف**: الحفاظ على البيئة وتعزيز الوعي المجتمعي

