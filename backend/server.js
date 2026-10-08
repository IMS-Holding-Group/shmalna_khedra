const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Database = require('./database');
const FormData = require('form-data');
const fetch = require('node-fetch');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'shmalna_khedra_secret_key_2024';
const ML_SERVICE_URL = process.env.ML_SERVICE_URL || 'http://localhost:5000';

// إعداد قاعدة البيانات
let db;

// تهيئة قاعدة البيانات
function initializeDatabase() {
    try {
        db = new Database();
        console.log('تم تهيئة قاعدة البيانات بنجاح');
    } catch (error) {
        console.error('خطأ في تهيئة قاعدة البيانات:', error);
        // إعادة المحاولة بعد 3 ثوان
        setTimeout(initializeDatabase, 3000);
    }
}

// إعداد multer لرفع الملفات
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const uploadDir = path.join(__dirname, 'uploads');
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 5 * 1024 * 1024 // 5MB
    },
    fileFilter: (req, file, cb) => {
        // تسجيل معلومات الملف للمساعدة في التصحيح
        console.log('معلومات الملف المرسل:', {
            fieldname: file.fieldname,
            originalname: file.originalname,
            mimetype: file.mimetype,
            encoding: file.encoding
        });

        // التحقق من mimetype
        if (file.mimetype && file.mimetype.startsWith('image/')) {
            console.log('✅ الملف مقبول - mimetype صحيح');
            cb(null, true);
            return;
        }

        // إذا لم يكن mimetype موجود، التحقق من امتداد الملف
        if (!file.originalname) {
            console.log('❌ الملف مرفوض - اسم الملف غير موجود');
            cb(new Error('اسم الملف غير موجود'), false);
            return;
        }

        const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
        const fileExtension = path.extname(file.originalname).toLowerCase();

        if (allowedExtensions.includes(fileExtension)) {
            console.log('✅ الملف مقبول - امتداد صحيح:', fileExtension);
            cb(null, true);
        } else {
            console.log('❌ الملف مرفوض - امتداد غير صحيح:', fileExtension);
            cb(new Error(`يجب أن يكون الملف صورة. الامتداد المدعوم: ${allowedExtensions.join(', ')}`), false);
        }
    }
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Middleware للتحقق من التوكن
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'مطلوب توكن للمصادقة' });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'توكن غير صالح' });
        }
        req.user = user;
        next();
    });
};

// Routes

// جلب جميع النباتات
app.get('/api/plants', (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    db.getAllPlants((err, plants) => {
        if (err) {
            console.error('خطأ في جلب النباتات:', err);
            return res.status(500).json({ error: 'خطأ في الخادم' });
        }
        res.json(plants);
    });
});

// جلب نبتة واحدة
app.get('/api/plants/:id', (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    const plantId = req.params.id;
    db.getPlantById(plantId, (err, plant) => {
        if (err) {
            console.error('خطأ في جلب النبتة:', err);
            return res.status(500).json({ error: 'خطأ في الخادم' });
        }
        if (!plant) {
            return res.status(404).json({ error: 'النبتة غير موجودة' });
        }
        res.json(plant);
    });
});

// تسجيل مستخدم جديد
app.post('/api/register', async (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    try {
        const { username, email, password } = req.body;

        // التحقق من صحة البيانات
        if (!username || !email || !password) {
            return res.status(400).json({ error: 'جميع الحقول مطلوبة' });
        }

        if (password.length < 6) {
            return res.status(400).json({ error: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' });
        }

        // التحقق من وجود المستخدم
        db.getUserByEmail(email, async (err, existingUser) => {
            if (err) {
                console.error('خطأ في البحث عن المستخدم:', err);
                return res.status(500).json({ error: 'خطأ في الخادم' });
            }

            if (existingUser) {
                return res.status(400).json({ error: 'البريد الإلكتروني مستخدم بالفعل' });
            }

            // تشفير كلمة المرور
            const hashedPassword = await bcrypt.hash(password, 10);

            // إضافة المستخدم
            db.addUser({ username, email, password: hashedPassword }, (err, userId) => {
                if (err) {
                    console.error('خطأ في إضافة المستخدم:', err);
                    return res.status(500).json({ error: 'خطأ في الخادم' });
                }

                // إنشاء توكن
                const token = jwt.sign(
                    { userId, username, email },
                    JWT_SECRET,
                    { expiresIn: '7d' }
                );

                res.status(201).json({
                    message: 'تم إنشاء الحساب بنجاح',
                    token,
                    user: { id: userId, username, email }
                });
            });
        });
    } catch (error) {
        console.error('خطأ في التسجيل:', error);
        res.status(500).json({ error: 'خطأ في الخادم' });
    }
});

// تسجيل الدخول
app.post('/api/login', async (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: 'البريد الإلكتروني وكلمة المرور مطلوبان' });
        }

        // البحث عن المستخدم
        db.getUserByEmail(email, async (err, user) => {
            if (err) {
                console.error('خطأ في البحث عن المستخدم:', err);
                return res.status(500).json({ error: 'خطأ في الخادم' });
            }

            if (!user) {
                return res.status(401).json({ error: 'بيانات الدخول غير صحيحة' });
            }

            // التحقق من كلمة المرور
            const isValidPassword = await bcrypt.compare(password, user.password);
            if (!isValidPassword) {
                return res.status(401).json({ error: 'بيانات الدخول غير صحيحة' });
            }

            // إنشاء توكن
            const token = jwt.sign(
                { userId: user.id, username: user.username, email: user.email },
                JWT_SECRET,
                { expiresIn: '7d' }
            );

            res.json({
                message: 'تم تسجيل الدخول بنجاح',
                token,
                user: { id: user.id, username: user.username, email: user.email }
            });
        });
    } catch (error) {
        console.error('خطأ في تسجيل الدخول:', error);
        res.status(500).json({ error: 'خطأ في الخادم' });
    }
});

// إضافة موقع مجتمعي جديد مع التعرف بالذكاء الاصطناعي
app.post('/api/community/add', authenticateToken, upload.single('image'), async (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    try {
        const { lat, lng, comment } = req.body;

        if (!lat || !lng) {
            return res.status(400).json({ error: 'الإحداثيات مطلوبة' });
        }

        if (!req.file) {
            return res.status(400).json({ error: 'الصورة مطلوبة' });
        }

        let plant_name = req.body.plant_name || null;
        let recognitionResult = null;

        // التعرف على النبات بالذكاء الاصطناعي إذا لم يتم تحديده
        if (!plant_name) {
            try {
                const formData = new FormData();
                formData.append('image', fs.createReadStream(req.file.path), {
                    filename: req.file.filename,
                    contentType: req.file.mimetype
                });

                const mlResponse = await fetch(`${ML_SERVICE_URL}/recognize`, {
                    method: 'POST',
                    body: formData
                });

                if (mlResponse.ok) {
                    recognitionResult = await mlResponse.json();
                    if (recognitionResult.success && recognitionResult.plant_name) {
                        plant_name = recognitionResult.plant_name;
                    }
                }
            } catch (mlError) {
                console.error('خطأ في التعرف على النبات:', mlError);
                // المتابعة بدون التعرف
            }
        }

        if (!plant_name) {
            // حذف الملف المؤقت
            if (req.file && fs.existsSync(req.file.path)) {
                fs.unlinkSync(req.file.path);
            }
            return res.status(400).json({
                error: 'لم يتم التعرف على النبات',
                message: 'لم يتم التعرف على النبات في الصورة. يرجى تحديد اسم النبات يدوياً أو التأكد من وضوح الصورة'
            });
        }

        const imagePath = req.file.filename;

        const pinData = {
            user_id: req.user.userId,
            plant_name,
            lat: parseFloat(lat),
            lng: parseFloat(lng),
            image_path: imagePath,
            comment: comment || null
        };

        db.addCommunityPin(pinData, (err, pinId) => {
            if (err) {
                console.error('خطأ في إضافة الموقع:', err);
                // حذف الملف المؤقت في حالة الخطأ
                if (req.file && fs.existsSync(req.file.path)) {
                    fs.unlinkSync(req.file.path);
                }
                return res.status(500).json({ error: 'خطأ في الخادم' });
            }

            // استخدام username من الـ token مباشرة
            const responsePin = {
                id: pinId,
                ...pinData,
                username: req.user.username || null
            };

            res.status(201).json({
                message: 'تم إضافة الموقع بنجاح',
                pin: responsePin,
                recognition: recognitionResult
            });
        });
    } catch (error) {
        console.error('خطأ في إضافة الموقع المجتمعي:', error);
        // حذف الملف المؤقت في حالة الخطأ
        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }
        res.status(500).json({ error: 'خطأ في الخادم' });
    }
});

// جلب جميع المواقع المجتمعية
app.get('/api/community/pins', (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    db.getAllCommunityPins((err, pins) => {
        if (err) {
            console.error('خطأ في جلب المواقع:', err);
            return res.status(500).json({ error: 'خطأ في الخادم' });
        }
        // التأكد من أن username موجود في كل pin
        const pinsWithUsername = pins.map(pin => ({
            ...pin,
            username: pin.username || null
        }));
        if (pinsWithUsername.length > 0) {
            console.log(`تم جلب ${pinsWithUsername.length} موقع`);
            console.log(`أول موقع - Plant: ${pinsWithUsername[0].plant_name}, User ID: ${pinsWithUsername[0].user_id}, Username: ${pinsWithUsername[0].username || 'NULL'}`);
        }
        res.json(pinsWithUsername);
    });
});

// endpoint للتحقق من البيانات (للتطوير فقط)
app.get('/api/debug/users', (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    db.db.all("SELECT id, username, email FROM users", (err, users) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ count: users.length, users });
    });
});

app.get('/api/debug/pins', (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    db.getAllCommunityPins((err, pins) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ count: pins.length, pins: pins.slice(0, 5) });
    });
});

// جلب صورة نبات من مجلد التدريب
app.get('/api/plants/:id/image', (req, res) => {
    const plantId = parseInt(req.params.id);

    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    db.getPlantById(plantId, (err, plant) => {
        if (err || !plant) {
            return res.status(404).json({ error: 'النبات غير موجود' });
        }

        const plantName = plant.name;
        const trainDir = path.join(__dirname, 'ml', 'data', 'train', plantName);

        if (!fs.existsSync(trainDir)) {
            return res.status(404).json({ error: 'مجلد التدريب غير موجود' });
        }

        // البحث عن أول صورة في المجلد
        const imageExtensions = ['.jpg', '.jpeg', '.png', '.JPG', '.JPEG', '.PNG', '.jpe'];
        let imageFile = null;

        const files = fs.readdirSync(trainDir);
        for (const file of files) {
            const ext = path.extname(file);
            if (imageExtensions.includes(ext)) {
                imageFile = path.join(trainDir, file);
                break;
            }
        }

        if (!imageFile) {
            return res.status(404).json({ error: 'لا توجد صور في مجلد التدريب' });
        }

        res.sendFile(path.resolve(imageFile));
    });
});

// التعرف على النبات من الصورة (AI)
app.post('/api/plants/recognize', upload.single('image'), async (req, res) => {
    if (!db) {
        return res.status(500).json({ error: 'قاعدة البيانات غير متاحة' });
    }

    try {
        if (!req.file) {
            return res.status(400).json({ error: 'لم يتم إرسال صورة' });
        }

        // إرسال الصورة لخدمة ML
        const formData = new FormData();
        formData.append('image', fs.createReadStream(req.file.path), {
            filename: req.file.filename,
            contentType: req.file.mimetype
        });

        let mlResponse;
        try {
            mlResponse = await fetch(`${ML_SERVICE_URL}/recognize`, {
                method: 'POST',
                body: formData
            });
        } catch (error) {
            console.error('خطأ في الاتصال بخدمة ML:', error);
            // حذف الملف المؤقت
            fs.unlinkSync(req.file.path);
            return res.status(503).json({
                error: 'خدمة التعرف غير متاحة حالياً',
                suggestion: 'يرجى المحاولة لاحقاً أو التأكد من تشغيل خدمة ML'
            });
        }

        const mlResult = await mlResponse.json();

        // حذف الملف المؤقت
        fs.unlinkSync(req.file.path);

        // البحث عن النبات في قاعدة البيانات
        db.getAllPlants((err, plants) => {
            if (err) {
                console.error('خطأ في جلب النباتات:', err);
                return res.status(500).json({ error: 'خطأ في الخادم' });
            }

            // فقط إذا نجح التعرف من النموذج
            if (mlResult.success && mlResult.plant_name) {
                const plantName = mlResult.plant_name;

                // البحث عن النبات بالاسم العربي
                let plant = plants.find(p =>
                    p.name === plantName ||
                    p.scientific_name.toLowerCase().includes(plantName.toLowerCase()) ||
                    (p.common_names && p.common_names.includes(plantName))
                );

                // إذا لم يتم العثور على النبات، جرب البحث في الأسماء الشائعة الأخرى
                if (!plant) {
                    plant = plants.find(p => {
                        const commonNames = (p.common_names || '').split(',').map(n => n.trim());
                        return commonNames.some(name => name === plantName);
                    });
                }

                if (plant) {
                    // النجاح - إرجاع معلومات النبات
                    return res.json({
                        success: true,
                        plant: plant,
                        recognition: {
                            plant_name: plantName,
                            confidence: mlResult.confidence,
                            confidence_percent: mlResult.confidence_percent,
                            alternatives: mlResult.alternatives || []
                        }
                    });
                }
            }

            // إذا لم يتم التعرف، أعد رسالة خطأ واضحة
            return res.status(400).json({
                success: false,
                error: mlResult.error || 'لم يتم التعرف على النبات',
                message: mlResult.message || 'لم يتم التعرف على النبات في الصورة. تأكد من أن الصورة واضحة وتحتوي على نبات فعلي من النباتات المدربة.',
                suggestions: mlResult.suggestions || 'تأكد من أن الصورة واضحة وتحتوي على نبات من النباتات المدربة',
                confidence: mlResult.confidence_percent || 0
            });
        });

    } catch (error) {
        console.error('خطأ في التعرف على النبات:', error);
        // تنظيف الملف المؤقت في حالة الخطأ
        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }
        res.status(500).json({ error: 'خطأ في الخادم' });
    }
});

// معالج الأخطاء
app.use((error, req, res, next) => {
    if (error instanceof multer.MulterError) {
        if (error.code === 'LIMIT_FILE_SIZE') {
            return res.status(400).json({ error: 'حجم الملف كبير جداً (الحد الأقصى 5MB)' });
        }
        return res.status(400).json({ error: error.message || 'خطأ في رفع الملف' });
    }

    // معالجة أخطاء fileFilter
    if (error.message && error.message.includes('يجب أن يكون الملف صورة')) {
        return res.status(400).json({ error: error.message });
    }
    console.error('خطأ غير متوقع:', error);
    res.status(500).json({ error: 'خطأ في الخادم' });
});

// تشغيل الخادم
app.listen(PORT, () => {
    console.log(`🚀 خادم شمالنا خضراء يعمل على المنفذ ${PORT}`);
    console.log(`📱 API متاح على: http://localhost:${PORT}/api`);
});

// تهيئة قاعدة البيانات
initializeDatabase();

// إغلاق قاعدة البيانات عند إيقاف الخادم
process.on('SIGINT', () => {
    console.log('\n🛑 إيقاف الخادم...');
    if (db) {
        db.close();
    }
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\n🛑 إيقاف الخادم...');
    if (db) {
        db.close();
    }
    process.exit(0);
});
