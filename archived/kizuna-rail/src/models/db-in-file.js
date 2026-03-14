import Fs from 'fs';
import routes from './seeds/routes.json' with { type: 'json' };
import schedules from './seeds/schedules.json' with { type: 'json' };
import stations from './seeds/stations.json' with { type: 'json' };
import ticketClasses from './seeds/ticket-classes.json' with { type: 'json' };

// In-memory database
let db = {};
let DATABASE_FILE;

const saveDatabase = () => {
    try {
        Fs.writeFileSync(DATABASE_FILE, JSON.stringify(db, null, 4), 'utf8');
        return true;
    } catch (error) {
        console.error('Error saving database:', error);
    }
    return false;
};

const initializeDatabase = (filePath) => {
    DATABASE_FILE = filePath;
    
    if (Fs.existsSync(DATABASE_FILE)) {
        try {
            const fileData = Fs.readFileSync(DATABASE_FILE, 'utf8');
            db = JSON.parse(fileData);
            console.log('✓ Database loaded from file');
        } catch (error) {
            console.error('Error loading database, using seed data:', error);
            db = {
                confirmations: [],
                routes,
                schedules,
                stations,
                ticketClasses
            };
            saveDatabase();
        }
    } else {
        console.log('✓ No existing database, seeding initial data');
        db = {
            confirmations: [],
            routes,
            schedules,
            stations,
            ticketClasses
        };
        if (saveDatabase()) {
            console.log('✓ Database saved to', DATABASE_FILE);
        };
    }
    
    // Wrap db in Proxy for auto-save on changes
    db = new Proxy(db, {
        set: (target, property, value) => {
            target[property] = value;
            saveDatabase();
            return true;
        }
    });
};

export { initializeDatabase, saveDatabase };
export const getDb = () => db;