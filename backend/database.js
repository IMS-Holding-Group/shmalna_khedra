const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

class Database {
    constructor() {
        this.db = new sqlite3.Database(path.join(__dirname, 'shmalna_khedra.db'), (err) => {
            if (err) {
                console.error('خطأ في الاتصال بقاعدة البيانات:', err);
            } else {
                console.log('تم الاتصال بقاعدة البيانات بنجاح');
                this.init();
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
                common_names TEXT,
                family TEXT,
                classification TEXT,
                environmental_importance TEXT,
                uses TEXT,
                location TEXT
            )
        `, (err) => {
            if (err) {
                console.error('خطأ في إنشاء جدول النباتات:', err);
            } else {
                console.log('تم إنشاء جدول النباتات بنجاح');
            }
        });

        // إنشاء جدول المستخدمين
        this.db.run(`
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                email TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `, (err) => {
            if (err) {
                console.error('خطأ في إنشاء جدول المستخدمين:', err);
            } else {
                console.log('تم إنشاء جدول المستخدمين بنجاح');
            }
        });

        // إنشاء جدول مواقع المجتمع
        this.db.run(`
            CREATE TABLE IF NOT EXISTS community_pins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER,
                plant_name TEXT NOT NULL,
                lat REAL NOT NULL,
                lng REAL NOT NULL,
                image_path TEXT,
                comment TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id)
            )
        `, (err) => {
            if (err) {
                console.error('خطأ في إنشاء جدول مواقع المجتمع:', err);
            } else {
                console.log('تم إنشاء جدول مواقع المجتمع بنجاح');
                // تحديث الجدول لإضافة عمود comment إذا لزم الأمر
                this.updateCommunityPinsTable();
                // إدراج البيانات الأولية بعد إنشاء جميع الجداول
                setTimeout(() => {
                    this.insertInitialData();
                }, 1000);
            }
        });
    }

    insertInitialData() {
        // التحقق من وجود بيانات
        this.db.get("SELECT COUNT(*) as count FROM plants", (err, row) => {
            if (err) {
                console.error('خطأ في التحقق من البيانات:', err);
                // إعادة المحاولة بعد ثانية واحدة
                setTimeout(() => {
                    this.insertInitialData();
                }, 1000);
                return;
            }

            if (row && row.count === 0) {
                console.log('إدراج البيانات الأولية للنباتات...');
                this.insertPlants();
            } else {
                // حذف النباتات القديمة وإعادة إدراجها من JSON
                console.log('تحديث النباتات من plants_data.json...');
                this.db.run("DELETE FROM plants", (err) => {
                    if (err) {
                        console.error('خطأ في حذف النباتات القديمة:', err);
                    } else {
                        console.log('تم حذف النباتات القديمة، إعادة إدراج من JSON...');
                        this.insertPlants();
                    }
                });
            }
        });

        // إضافة بيانات افتراضية للمستخدمين
        this.db.get("SELECT COUNT(*) as count FROM users", (err, row) => {
            if (err) {
                console.error('خطأ في التحقق من المستخدمين:', err);
                return;
            }

            if (row && row.count === 0) {
                console.log('إدراج المستخدمين الافتراضيين...');
                this.insertDefaultUsers();
            }
        });

        // إضافة بيانات افتراضية للمواقع المجتمعية
        this.db.get("SELECT COUNT(*) as count FROM community_pins", (err, row) => {
            if (err) {
                console.error('خطأ في التحقق من المواقع:', err);
                return;
            }

            if (row && row.count === 0) {
                console.log('إدراج المواقع المجتمعية الافتراضية...');
                // انتظار إنشاء المستخدمين أولاً
                setTimeout(() => {
                    this.insertDefaultPins();
                }, 2000);
            } else {
                // حذف المواقع القديمة وإعادة إدراجها من JSON
                console.log('تحديث المواقع المجتمعية من plants_data.json...');
                this.db.run("DELETE FROM community_pins", (err) => {
                    if (err) {
                        console.error('خطأ في حذف المواقع القديمة:', err);
                    } else {
                        console.log('تم حذف المواقع القديمة، إعادة إدراج من JSON...');
                        setTimeout(() => {
                            this.insertDefaultPins();
                        }, 1000);
                    }
                });
            }
        });
    }

    insertPlants() {
        // قراءة النباتات من ملف JSON
        const jsonPath = path.join(__dirname, 'plants_data.json');
        let plantsData = [];

        try {
            const jsonContent = fs.readFileSync(jsonPath, 'utf8');
            plantsData = JSON.parse(jsonContent);
            console.log(`تم قراءة ${plantsData.length} نبات من plants_data.json`);
        } catch (err) {
            console.error('خطأ في قراءة plants_data.json:', err);
            return;
        }

        // تحويل بيانات JSON إلى تنسيق قاعدة البيانات
        const plants = plantsData.map(plantData => ({
            name: plantData['الاسم_الشائع_الرئيسي'] || '',
            scientific_name: plantData['الاسم_العلمي_المختصر'] || '',
            common_names: [
                plantData['الاسم_الشائع_الرئيسي'],
                ...(plantData['الأسماء_الشائعة_الأخرى'] || [])
            ].join(', '),
            family: plantData['التصنيف']?.['الفصيلة'] || '',
            classification: [
                plantData['التصنيف']?.['الرتبة'] || '',
                plantData['التصنيف']?.['الفصيلة'] || '',
                plantData['التصنيف']?.['الجنس'] || ''
            ].filter(Boolean).join(' | '),
            environmental_importance: plantData['الفوائد_البيئية_والطبية'] || '',
            uses: (plantData['الاستخدامات'] || []).join('. '),
            location: plantData['الموطن'] || ''
        }));

        const stmt = this.db.prepare(`
            INSERT INTO plants (name, scientific_name, common_names, family, classification, environmental_importance, uses, location)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `);

        let insertedCount = 0;
        plants.forEach(plant => {
            stmt.run([
                plant.name,
                plant.scientific_name,
                plant.common_names,
                plant.family,
                plant.classification,
                plant.environmental_importance,
                plant.uses,
                plant.location
            ], function (err) {
                if (err) {
                    console.error(`خطأ في إدراج نبتة ${plant.name}:`, err);
                } else {
                    insertedCount++;
                    console.log(`تم إدراج نبتة: ${plant.name}`);
                }
            });
        });

        stmt.finalize((err) => {
            if (err) {
                console.error('خطأ في إنهاء إدراج البيانات:', err);
            } else {
                console.log(`تم إدراج ${insertedCount} نبتة بنجاح`);
            }
        });
    }

    // الحصول على جميع النباتات
    getAllPlants(callback) {
        this.db.all("SELECT * FROM plants ORDER BY name", (err, rows) => {
            if (err) {
                return callback(err);
            }
            // إضافة image_url لكل نبات
            const plantsWithImages = rows.map(plant => ({
                ...plant,
                image_url: `/api/plants/${plant.id}/image`
            }));
            callback(null, plantsWithImages);
        });
    }

    // الحصول على نبتة واحدة
    getPlantById(id, callback) {
        this.db.get("SELECT * FROM plants WHERE id = ?", [id], callback);
    }

    // إضافة مستخدم جديد
    addUser(user, callback) {
        const stmt = this.db.prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
        stmt.run([user.username, user.email, user.password], function (err) {
            callback(err, this.lastID);
        });
        stmt.finalize();
    }

    // البحث عن مستخدم بالبريد الإلكتروني
    getUserByEmail(email, callback) {
        this.db.get("SELECT * FROM users WHERE email = ?", [email], callback);
    }

    // البحث عن مستخدم بالمعرف
    getUserById(id, callback) {
        this.db.get("SELECT * FROM users WHERE id = ?", [id], callback);
    }

    // إضافة موقع مجتمعي جديد
    addCommunityPin(pin, callback) {
        const stmt = this.db.prepare(`
            INSERT INTO community_pins (user_id, plant_name, lat, lng, image_path, comment)
            VALUES (?, ?, ?, ?, ?, ?)
        `);
        stmt.run([pin.user_id, pin.plant_name, pin.lat, pin.lng, pin.image_path, pin.comment || null], function (err) {
            callback(err, this.lastID);
        });
        stmt.finalize();
    }

    // الحصول على جميع المواقع المجتمعية
    getAllCommunityPins(callback) {
        this.db.all(`
            SELECT cp.*, 
                   u.username as username 
            FROM community_pins cp 
            LEFT JOIN users u ON cp.user_id = u.id
            ORDER BY cp.created_at DESC
        `, callback);
    }

    // تحديث جدول community_pins لإضافة عمود comment إذا لم يكن موجوداً
    updateCommunityPinsTable() {
        this.db.run(`
            ALTER TABLE community_pins ADD COLUMN comment TEXT
        `, (err) => {
            if (err && !err.message.includes('duplicate column name')) {
                console.error('خطأ في تحديث جدول community_pins:', err);
            }
        });
    }

    // دالة مساعدة لجلب أول صورة من مجلد التدريب
    getFirstImageFromTrainFolder(plantName) {
        const trainDir = path.join(__dirname, 'ml', 'data', 'train', plantName);
        if (!fs.existsSync(trainDir)) {
            return null;
        }

        const imageExtensions = ['.jpg', '.jpeg', '.png', '.JPG', '.JPEG', '.PNG', '.jpe'];
        const files = fs.readdirSync(trainDir);

        for (const file of files) {
            const ext = path.extname(file);
            if (imageExtensions.includes(ext)) {
                return file;
            }
        }
        return null;
    }

    // دالة مساعدة لنسخ صورة من مجلد التدريب إلى uploads
    copyImageToUploads(plantName, imageFileName) {
        const trainImagePath = path.join(__dirname, 'ml', 'data', 'train', plantName, imageFileName);
        const uploadsDir = path.join(__dirname, 'uploads');

        if (!fs.existsSync(uploadsDir)) {
            fs.mkdirSync(uploadsDir, { recursive: true });
        }

        if (!fs.existsSync(trainImagePath)) {
            return null;
        }

        const newFileName = `default_${plantName}_${Date.now()}_${imageFileName}`;
        const destPath = path.join(uploadsDir, newFileName);

        try {
            fs.copyFileSync(trainImagePath, destPath);
            return newFileName;
        } catch (err) {
            console.error(`خطأ في نسخ الصورة ${plantName}/${imageFileName}:`, err);
            return null;
        }
    }

    // إضافة مستخدمين افتراضيين
    insertDefaultUsers() {
        const bcrypt = require('bcryptjs');
        const defaultUsers = [
            { username: 'أحمد العتيبي', email: 'ahmed@example.com', password: '' },
            { username: 'فاطمة الربيع', email: 'fatima@example.com', password: '' },
            { username: 'خالد المطيري', email: 'khalid@example.com', password: '' },
            { username: 'سارة الدوسري', email: 'sara@example.com', password: '' },
            { username: 'محمد الأحمد', email: 'mohammed@example.com', password: '' },
            { username: 'نورة الزهراني', email: 'nora@example.com', password: '' },
            { username: 'عبدالله القحطاني', email: 'abdullah1@example.com', password: '' },
            { username: 'عبدالله الغامدي', email: 'abdullah2@example.com', password: '' },
            { username: 'لينا السعود', email: 'lina@example.com', password: '' },
            { username: 'مشعل الحربي', email: 'mishal@example.com', password: '' },
            { username: 'ريم الشمري', email: 'reem@example.com', password: '' },
            { username: 'ياسر الدخيل', email: 'yasser@example.com', password: '' }
        ];

        let completed = 0;
        const total = defaultUsers.length;

        defaultUsers.forEach((user) => {
            // تشفير كلمة المرور
            bcrypt.hash(user.password, 10, (err, hashedPassword) => {
                if (err) {
                    console.error(`خطأ في تشفير كلمة المرور لـ ${user.username}:`, err);
                    completed++;
                    if (completed === total) {
                        console.log('انتهى إدراج المستخدمين الافتراضيين');
                    }
                    return;
                }

                // استخدام statement جديد لكل مستخدم
                const stmt = this.db.prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
                stmt.run([user.username, user.email, hashedPassword], function (insertErr) {
                    if (insertErr) {
                        if (insertErr.message.includes('UNIQUE constraint')) {
                            console.log(`المستخدم ${user.username} موجود بالفعل`);
                        } else {
                            console.error(`خطأ في إدراج المستخدم ${user.username}:`, insertErr);
                        }
                    } else {
                        console.log(`تم إدراج المستخدم: ${user.username} (ID: ${this.lastID})`);
                    }
                    stmt.finalize();

                    completed++;
                    if (completed === total) {
                        console.log('انتهى إدراج المستخدمين الافتراضيين');
                    }
                });
            });
        });
    }

    // إضافة مواقع افتراضية
    insertDefaultPins() {
        // قراءة النباتات من JSON لاستخدامها في المواقع الافتراضية
        const jsonPath = path.join(__dirname, 'plants_data.json');
        let plantsData = [];

        try {
            const jsonContent = fs.readFileSync(jsonPath, 'utf8');
            plantsData = JSON.parse(jsonContent);
        } catch (err) {
            console.error('خطأ في قراءة plants_data.json للمواقع الافتراضية:', err);
            return;
        }

        // جلب جميع المستخدمين من قاعدة البيانات
        this.db.all("SELECT id, username FROM users ORDER BY id", (err, users) => {
            if (err) {
                console.error('خطأ في جلب المستخدمين:', err);
                return;
            }

            if (!users || users.length === 0) {
                console.log('لا يوجد مستخدمين في قاعدة البيانات، سيتم إنشاء المواقع بدون user_id');
                users = [];
            }

            // إنشاء مواقع افتراضية في مناطق مختلفة بعرعر مع صور حقيقية
            const defaultPins = [];
            const comments = [
                'شجرة جميلة في منطقة المطار، ثمارها ناضجة ومفيدة',
                'شجرة كبيرة توفر ظلاً ممتازاً في الصحراء',
                'نبات مزهر بألوان زاهية، نادر في المنطقة',
                'نبات بري برائحة عطرية مميزة، صالح للأكل',
                'زهرة برية جميلة، تجذب النحل والحشرات',
                'نبات يزهر باللون الأصفر المشرق في الربيع',
                'نبات مفيد للرعي، غذاء ممتاز للماشية',
                'نبات صالح للأكل، يستخدم في الطبخ والطب الشعبي',
                'نبات عطري برائحة قوية، يستخدم كبخور',
                'نبات مقاوم للملوحة، ينمو في الأراضي القلوية',
                'نبات مقاوم للجفاف، ينمو في المناطق الصحراوية',
                'نبات معمر دائم الخضرة، يتحمل الظروف القاسية'
            ];

            // إنشاء موقع لكل نبات
            plantsData.forEach((plant, index) => {
                const plantName = plant['الاسم_الشائع_الرئيسي'] || '';
                if (!plantName) return;

                // جلب أول صورة من مجلد التدريب
                const imageFileName = this.getFirstImageFromTrainFolder(plantName);
                if (!imageFileName) {
                    console.log(`⚠️ لا توجد صور لـ ${plantName}`);
                    return;
                }

                // نسخ الصورة إلى مجلد uploads
                const copiedFileName = this.copyImageToUploads(plantName, imageFileName);
                if (!copiedFileName) {
                    console.log(`⚠️ فشل في نسخ صورة ${plantName}`);
                    return;
                }

                // إحداثيات عشوائية في منطقة عرعر
                const baseLat = 30.9753;
                const baseLng = 41.0381;
                const latOffset = (Math.random() - 0.5) * 0.03;
                const lngOffset = (Math.random() - 0.5) * 0.03;

                // استخدام user_id من قاعدة البيانات (أو null إذا لم يكن موجود)
                const userIndex = index % users.length;
                const userId = users.length > 0 ? users[userIndex].id : null;

                defaultPins.push({
                    user_id: userId,
                    plant_name: plantName,
                    lat: baseLat + latOffset,
                    lng: baseLng + lngOffset,
                    image_path: copiedFileName,
                    comment: comments[index % comments.length]
                });
            });

            const stmt = this.db.prepare(`
                INSERT INTO community_pins (user_id, plant_name, lat, lng, image_path, comment)
                VALUES (?, ?, ?, ?, ?, ?)
            `);

            defaultPins.forEach(pin => {
                stmt.run([pin.user_id, pin.plant_name, pin.lat, pin.lng, pin.image_path, pin.comment], function (err) {
                    if (err) {
                        console.error(`خطأ في إدراج موقع ${pin.plant_name}:`, err);
                    } else {
                        const username = users.length > 0 && pin.user_id
                            ? users.find(u => u.id === pin.user_id)?.username || 'مستخدم'
                            : 'مستخدم';
                        console.log(`تم إدراج موقع: ${pin.plant_name} من قبل ${username}`);
                    }
                });
            });

            stmt.finalize();
        });
    }

    close() {
        this.db.close((err) => {
            if (err) {
                console.error('خطأ في إغلاق قاعدة البيانات:', err);
            } else {
                console.log('تم إغلاق قاعدة البيانات بنجاح');
            }
        });
    }
}

module.exports = Database;
