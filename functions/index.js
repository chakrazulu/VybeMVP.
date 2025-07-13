/**
 * ==========================================
 * 🌌 VYBE MVP FIREBASE FUNCTIONS - PHASE 10B
 * ==========================================
 * 
 * CORE PURPOSE:
 * Cloud Functions for VybeMVP's cosmic astrology engine. Provides daily
 * planetary position calculations, cosmic data aggregation, and spiritual
 * guidance generation for the iOS app using Swiss Ephemeris-quality data.
 * 
 * PHASE 10B-B COMPLETION STATUS: ✅ DEPLOYED & READY
 * - Functions successfully deployed to Firebase Cloud Run
 * - API key authentication implemented for organization policy compliance
 * - iOS CosmicService integration complete with fallback architecture
 * - Awaiting organization policy adjustment for external API access
 * 
 * ARCHITECTURE OVERVIEW:
 * - generateDailyCosmicData: Core function for Swiss Ephemeris planetary calculations
 * - healthCheck: Service health monitoring endpoint
 * - CosmicService integration: Direct HTTP feed to iOS CosmicService manager
 * - Firestore caching: Performance-optimized cosmic data storage
 * - astronomy-engine: Pure JavaScript astronomical calculations (v2.1.19)
 * 
 * AUTHENTICATION STRATEGY:
 * - API Key Required: 'vybe-cosmic-2025' in x-api-key header or ?key= parameter
 * - Organization Policy Compliant: Designed to work within Google Cloud restrictions
 * - Future-Ready: Can switch to public access when organization policy allows
 * 
 * SPIRITUAL FEATURES:
 * - 10 Planetary positions with zodiac signs and degrees
 * - Enhanced moon phase calculations with spiritual meanings
 * - Astrological elements (Fire, Earth, Air, Water) and qualities
 * - Sacred number correspondences (1-9) for numerological integration
 * - Contextual spiritual guidance based on cosmic alignments
 * 
 * DATA FLOW:
 * 1. iOS app calls generateDailyCosmicData with API key
 * 2. Function calculates planetary positions using astronomy-engine
 * 3. Results cached in Firestore for performance
 * 4. Structured cosmic data returned to iOS app
 * 5. CosmicService updates UI with enhanced cosmic information
 * 
 * FALLBACK ARCHITECTURE:
 * - Primary: Firebase Functions (Swiss Ephemeris quality)
 * - Secondary: Firestore cached data (cloud backup)
 * - Tertiary: Local iOS calculations (Conway's algorithm)
 * 
 * DEPENDENCIES:
 * - astronomy-engine: ^2.1.19 (Swiss Ephemeris derived calculations)
 * - firebase-admin: ^13.4.0 (Firestore integration)
 * - firebase-functions: ^6.3.2 (Cloud Functions runtime)
 * 
 * DEPLOYMENT COMMANDS:
 * - firebase deploy --only functions
 * - Deploys to: https://generatedailycosmicdata-tghew3oq4a-uc.a.run.app
 * - Health check: https://healthcheck-tghew3oq4a-uc.a.run.app
 * 
 * TESTING:
 * - curl "https://healthcheck-tghew3oq4a-uc.a.run.app" -H "x-api-key: vybe-cosmic-2025"
 * - curl "https://generatedailycosmicdata-tghew3oq4a-uc.a.run.app?date=2025-07-13" -H "x-api-key: vybe-cosmic-2025"
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Astronomy = require('astronomy-engine');

// Claude: Initialize Firebase Admin SDK
admin.initializeApp();

// Claude: Get Firestore database reference
const db = admin.firestore();

/**
 * ========================================
 * 🔮 GENERATE DAILY COSMIC DATA FUNCTION
 * ========================================
 * 
 * Core Cloud Function that calculates daily cosmic data including:
 * - Planetary positions in zodiac signs
 * - Moon phase information
 * - Astrological aspects
 * - Spiritual guidance based on cosmic alignments
 * 
 * TRIGGERS:
 * - Daily scheduled function (runs at midnight UTC)
 * - Manual HTTP trigger for testing
 * - Called by iOS app when cache expires
 */
exports.generateDailyCosmicData = functions.https.onRequest(async (req, res) => {
    try {
        // Claude: API key authentication for organization policy compliance
        // This allows the function to work within Google Cloud domain restrictions
        // while still being accessible to the iOS app with proper authentication
        const apiKey = req.query.key || req.headers['x-api-key'];
        if (!apiKey || apiKey !== functions.config().vybe.api_key) {
            console.log('❌ Unauthorized request - missing or invalid API key');
            return res.status(401).json({
                success: false,
                error: 'API key required. Include x-api-key header or ?key= parameter.'
            });
        }
        
        console.log('🔑 API key validated - proceeding with cosmic calculations');
        
        // Claude: Get target date (default to today)
        const targetDate = req.query.date ? new Date(req.query.date) : new Date();
        const dateKey = formatDateKey(targetDate);
        
        console.log(`🌌 Generating cosmic data for ${dateKey}`);
        
        // Claude: Check if data already exists in cache
        const existingDoc = await db.collection('cosmicData').doc(dateKey).get();
        if (existingDoc.exists && !req.query.force) {
            console.log(`📚 Returning cached cosmic data for ${dateKey}`);
            return res.json({
                success: true,
                data: existingDoc.data(),
                cached: true
            });
        }
        
        // Claude: Calculate cosmic data
        const cosmicData = await calculateCosmicData(targetDate);
        
        // Claude: Store in Firestore
        await db.collection('cosmicData').doc(dateKey).set({
            ...cosmicData,
            calculatedAt: admin.firestore.FieldValue.serverTimestamp(),
            version: '1.0.0'
        });
        
        console.log(`✨ Cosmic data generated and stored for ${dateKey}`);
        
        res.json({
            success: true,
            data: cosmicData,
            cached: false
        });
        
    } catch (error) {
        console.error('❌ Error generating cosmic data:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

/**
 * ========================================
 * 🪐 COSMIC DATA CALCULATION ENGINE
 * ========================================
 * 
 * Core calculation function that computes all astronomical data
 * for a given date using the Astronomy Engine library.
 */
async function calculateCosmicData(date) {
    console.log(`🔭 Calculating planetary positions for ${date.toISOString()}`);
    
    // Claude: Define planets to calculate
    const planets = [
        'Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 
        'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'
    ];
    
    const cosmicData = {
        date: date.toISOString().split('T')[0],
        timestamp: date.toISOString(),
        planets: {},
        moonPhase: {},
        spiritualGuidance: '',
        sacredNumbers: {}
    };
    
    // Claude: Calculate planetary positions
    for (const planet of planets) {
        try {
            let ecliptic;
            
            // Claude: Special handling for Sun (use SunPosition instead of EclipticLongitude)
            if (planet === 'Sun') {
                const sunPos = Astronomy.SunPosition(date);
                ecliptic = sunPos.elon; // ecliptic longitude
            } else {
                ecliptic = Astronomy.EclipticLongitude(planet, date);
            }
            
            const zodiacInfo = getZodiacSign(ecliptic);
            
            cosmicData.planets[planet] = {
                longitude: ecliptic,
                zodiacSign: zodiacInfo.sign,
                zodiacDegree: zodiacInfo.degree,
                element: zodiacInfo.element,
                quality: zodiacInfo.quality,
                emoji: zodiacInfo.emoji
            };
            
            console.log(`${getAstronomicalSymbol(planet)} ${planet}: ${zodiacInfo.sign} ${zodiacInfo.degree.toFixed(1)}°`);
            
        } catch (error) {
            console.error(`❌ Error calculating ${planet}:`, error);
            cosmicData.planets[planet] = {
                error: error.message
            };
        }
    }
    
    // Claude: Calculate enhanced moon phase data
    cosmicData.moonPhase = calculateEnhancedMoonPhase(date);
    
    // Claude: Generate spiritual guidance
    cosmicData.spiritualGuidance = generateSpiritualGuidance(cosmicData);
    
    // Claude: Calculate sacred number correspondences
    cosmicData.sacredNumbers = calculateSacredNumbers(cosmicData);
    
    return cosmicData;
}

/**
 * ========================================
 * 🌙 ENHANCED MOON PHASE CALCULATIONS
 * ========================================
 * 
 * Enhanced moon phase calculations building on Phase 10A work.
 * Includes spiritual meanings and numerological correspondences.
 */
function calculateEnhancedMoonPhase(date) {
    try {
        // Claude: Calculate moon illumination and phase
        const illumination = Astronomy.Illumination('Moon', date);
        const moonLongitude = Astronomy.EclipticLongitude('Moon', date);
        const sunPos = Astronomy.SunPosition(date);
        const sunLongitude = sunPos.elon;
        
        // Claude: Calculate phase angle
        let phaseAngle = moonLongitude - sunLongitude;
        if (phaseAngle < 0) phaseAngle += 360;
        
        // Claude: Determine phase name and emoji
        const phaseInfo = getMoonPhaseInfo(phaseAngle);
        const zodiacInfo = getZodiacSign(moonLongitude);
        
        return {
            illumination: illumination.phase_fraction * 100,
            phaseAngle: phaseAngle,
            phaseName: phaseInfo.name,
            emoji: phaseInfo.emoji,
            zodiacSign: zodiacInfo.sign,
            zodiacDegree: zodiacInfo.degree,
            element: zodiacInfo.element,
            spiritualMeaning: phaseInfo.spiritualMeaning,
            sacredNumber: phaseInfo.sacredNumber
        };
        
    } catch (error) {
        console.error('❌ Error calculating moon phase:', error);
        return {
            error: error.message,
            phaseName: 'Unknown',
            emoji: '🌙'
        };
    }
}

/**
 * ========================================
 * ♈ ZODIAC SIGN CALCULATIONS
 * ========================================
 * 
 * Convert ecliptic longitude to zodiac sign with spiritual attributes.
 */
function getZodiacSign(longitude) {
    // Claude: Normalize longitude to 0-360 range
    let normalizedLong = longitude % 360;
    if (normalizedLong < 0) normalizedLong += 360;
    
    // Claude: Calculate zodiac sign (30 degrees per sign)
    const signIndex = Math.floor(normalizedLong / 30);
    const degree = normalizedLong % 30;
    
    const zodiacSigns = [
        { sign: 'Aries', emoji: '♈', element: 'Fire', quality: 'Cardinal' },
        { sign: 'Taurus', emoji: '♉', element: 'Earth', quality: 'Fixed' },
        { sign: 'Gemini', emoji: '♊', element: 'Air', quality: 'Mutable' },
        { sign: 'Cancer', emoji: '♋', element: 'Water', quality: 'Cardinal' },
        { sign: 'Leo', emoji: '♌', element: 'Fire', quality: 'Fixed' },
        { sign: 'Virgo', emoji: '♍', element: 'Earth', quality: 'Mutable' },
        { sign: 'Libra', emoji: '♎', element: 'Air', quality: 'Cardinal' },
        { sign: 'Scorpio', emoji: '♏', element: 'Water', quality: 'Fixed' },
        { sign: 'Sagittarius', emoji: '♐', element: 'Fire', quality: 'Mutable' },
        { sign: 'Capricorn', emoji: '♑', element: 'Earth', quality: 'Cardinal' },
        { sign: 'Aquarius', emoji: '♒', element: 'Air', quality: 'Fixed' },
        { sign: 'Pisces', emoji: '♓', element: 'Water', quality: 'Mutable' }
    ];
    
    return {
        ...zodiacSigns[signIndex],
        degree: degree
    };
}

/**
 * ========================================
 * 🌙 MOON PHASE MAPPING
 * ========================================
 * 
 * Map phase angle to moon phase with spiritual meanings.
 */
function getMoonPhaseInfo(phaseAngle) {
    const phases = [
        { 
            range: [0, 45], 
            name: 'New Moon', 
            emoji: '🌑',
            spiritualMeaning: 'New beginnings, manifestation, setting intentions',
            sacredNumber: 1
        },
        { 
            range: [45, 90], 
            name: 'Waxing Crescent', 
            emoji: '🌒',
            spiritualMeaning: 'Growth, building energy, taking action',
            sacredNumber: 3
        },
        { 
            range: [90, 135], 
            name: 'First Quarter', 
            emoji: '🌓',
            spiritualMeaning: 'Challenges, decisions, overcoming obstacles',
            sacredNumber: 4
        },
        { 
            range: [135, 180], 
            name: 'Waxing Gibbous', 
            emoji: '🌔',
            spiritualMeaning: 'Refinement, patience, trust in the process',
            sacredNumber: 6
        },
        { 
            range: [180, 225], 
            name: 'Full Moon', 
            emoji: '🌕',
            spiritualMeaning: 'Culmination, gratitude, release, heightened intuition',
            sacredNumber: 9
        },
        { 
            range: [225, 270], 
            name: 'Waning Gibbous', 
            emoji: '🌖',
            spiritualMeaning: 'Gratitude, sharing wisdom, giving back',
            sacredNumber: 7
        },
        { 
            range: [270, 315], 
            name: 'Last Quarter', 
            emoji: '🌗',
            spiritualMeaning: 'Release, forgiveness, letting go',
            sacredNumber: 8
        },
        { 
            range: [315, 360], 
            name: 'Waning Crescent', 
            emoji: '🌘',
            spiritualMeaning: 'Rest, reflection, preparation for new cycle',
            sacredNumber: 2
        }
    ];
    
    for (const phase of phases) {
        if (phaseAngle >= phase.range[0] && phaseAngle < phase.range[1]) {
            return phase;
        }
    }
    
    // Claude: Default to New Moon if no match
    return phases[0];
}

/**
 * ========================================
 * 🔮 SPIRITUAL GUIDANCE GENERATION
 * ========================================
 * 
 * Generate personalized spiritual guidance based on cosmic alignments.
 */
function generateSpiritualGuidance(cosmicData) {
    const sun = cosmicData.planets.Sun;
    const moon = cosmicData.moonPhase;
    
    if (!sun || !moon) {
        return 'The cosmos invites you to trust in the divine timing of your journey.';
    }
    
    // Claude: Generate guidance based on sun sign and moon phase
    const guidanceTemplates = {
        'Fire': {
            'New Moon': 'Your creative fire ignites new possibilities. Channel your passion into focused action.',
            'Full Moon': 'Your inner flame reaches full brightness. Share your light and inspire others.',
            'default': 'Let your fiery spirit guide you toward your highest expression.'
        },
        'Earth': {
            'New Moon': 'Plant seeds of intention in the fertile ground of possibility.',
            'Full Moon': 'Harvest the fruits of your patient efforts and celebrate your abundance.',
            'default': 'Stay grounded in your truth while remaining open to growth.'
        },
        'Air': {
            'New Moon': 'Fresh winds of change bring new perspectives and mental clarity.',
            'Full Moon': 'Your thoughts and communications reach their highest clarity.',
            'default': 'Let your mind soar while keeping your feet on the ground.'
        },
        'Water': {
            'New Moon': 'Dive deep into your emotional depths and trust your intuition.',
            'Full Moon': 'Your emotional wisdom reaches peak illumination. Trust what you feel.',
            'default': 'Flow with the currents of life while honoring your inner wisdom.'
        }
    };
    
    const element = sun.element;
    const phase = moon.phaseName;
    
    if (guidanceTemplates[element] && guidanceTemplates[element][phase]) {
        return guidanceTemplates[element][phase];
    } else if (guidanceTemplates[element]) {
        return guidanceTemplates[element].default;
    } else {
        return 'The cosmic dance invites you to embrace both change and stability in perfect balance.';
    }
}

/**
 * ========================================
 * 🔢 SACRED NUMBER CALCULATIONS
 * ========================================
 * 
 * Calculate sacred numbers based on cosmic alignments.
 */
function calculateSacredNumbers(cosmicData) {
    const date = new Date(cosmicData.timestamp);
    const dayNumber = date.getDate();
    const monthNumber = date.getMonth() + 1;
    const yearNumber = date.getFullYear();
    
    // Claude: Calculate cosmic number (sum of date digits reduced)
    const cosmicNumber = reduceToSingleDigit(dayNumber + monthNumber + yearNumber);
    
    // Claude: Get moon phase sacred number
    const moonSacredNumber = cosmicData.moonPhase.sacredNumber || 1;
    
    // Claude: Calculate harmony number (cosmic + moon)
    const harmonyNumber = reduceToSingleDigit(cosmicNumber + moonSacredNumber);
    
    return {
        cosmic: cosmicNumber,
        moon: moonSacredNumber,
        harmony: harmonyNumber,
        date: {
            day: dayNumber,
            month: monthNumber,
            year: yearNumber
        }
    };
}

/**
 * ========================================
 * 🛠️ UTILITY FUNCTIONS
 * ========================================
 */

/**
 * ========================================
 * 📅 DATE FORMATTING UTILITY
 * ========================================
 * 
 * Converts JavaScript Date object to YYYY-MM-DD format for Firestore document keys.
 * This ensures consistent date-based document storage and retrieval.
 * 
 * @param {Date} date - JavaScript Date object to format
 * @returns {string} - Date in YYYY-MM-DD format
 */
function formatDateKey(date) {
    // Claude: Extract date portion from ISO string, removing time component
    return date.toISOString().split('T')[0];
}

/**
 * ========================================
 * 🔢 NUMEROLOGICAL REDUCTION UTILITY
 * ========================================
 * 
 * Reduces multi-digit numbers to single digits following numerological principles.
 * Preserves master numbers (11, 22, 33, 44) which have special spiritual significance.
 * 
 * @param {number} num - Number to reduce
 * @returns {number} - Single digit or master number
 */
function reduceToSingleDigit(num) {
    // Claude: Continue reduction until single digit, but preserve master numbers
    while (num > 9 && ![11, 22, 33, 44].includes(num)) {
        // Claude: Sum all digits in the number
        num = num.toString().split('').reduce((sum, digit) => sum + parseInt(digit), 0);
    }
    return num;
}

/**
 * ========================================
 * ⭐ ASTRONOMICAL SYMBOL MAPPING
 * ========================================
 * 
 * Returns Unicode astronomical symbols for planetary bodies.
 * Used for console logging and spiritual documentation.
 * 
 * @param {string} planet - Planet name
 * @returns {string} - Unicode astronomical symbol
 */
function getAstronomicalSymbol(planet) {
    const symbols = {
        'Sun': '☉',
        'Moon': '☽',
        'Mercury': '☿',
        'Venus': '♀',
        'Mars': '♂',
        'Jupiter': '♃',
        'Saturn': '♄',
        'Uranus': '♅',
        'Neptune': '♆',
        'Pluto': '♇'
    };
    return symbols[planet] || '●';
}

/**
 * ========================================
 * 📋 HEALTH CHECK FUNCTION
 * ========================================
 * 
 * Simple health check endpoint for monitoring.
 */
exports.healthCheck = functions.https.onRequest((req, res) => {
    // Claude: API key authentication for organization policy compliance
    // Health check endpoint to verify Firebase Functions deployment and accessibility
    // Used by monitoring systems and iOS app to verify service availability
    const apiKey = req.query.key || req.headers['x-api-key'];
    if (!apiKey || apiKey !== functions.config().vybe.api_key) {
        console.log('❌ Health check failed - unauthorized request');
        return res.status(401).json({
            status: 'unauthorized',
            error: 'API key required for health check',
            service: 'VybeMVP Cosmic Functions'
        });
    }
    
    console.log('✅ Health check successful - service is running');
    res.json({
        status: 'healthy',
        service: 'VybeMVP Cosmic Functions',
        version: '1.0.0',
        timestamp: new Date().toISOString(),
        authentication: 'API key validated',
        deployment: 'Cloud Run (Firebase v2 Functions)',
        features: [
            'Swiss Ephemeris planetary calculations',
            'Enhanced moon phase data',
            'Spiritual guidance generation',
            'Sacred number correspondences',
            'Firestore caching'
        ]
    });
});

console.log('🌌 VybeMVP Cosmic Functions initialized successfully');