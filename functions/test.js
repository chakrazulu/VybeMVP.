/**
 * ==========================================
 * 🧪 COSMIC FUNCTIONS TEST SCRIPT
 * ==========================================
 * 
 * Test script to validate cosmic calculations without Firebase dependencies.
 * This helps ensure our astronomical calculations work correctly.
 */

const Astronomy = require('astronomy-engine');

console.log('🧪 Starting Cosmic Functions Test...\n');

/**
 * Test the astronomical calculations
 */
function testAstronomicalCalculations() {
    console.log('🔭 Testing Astronomical Calculations:');
    console.log('=====================================');
    
    const testDate = new Date('2025-07-13T12:00:00Z');
    console.log(`📅 Test Date: ${testDate.toISOString()}\n`);
    
    // Test planetary calculations
    const planets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn'];
    
    planets.forEach(planet => {
        try {
            let ecliptic;
            
            // Special handling for Sun (use SunPosition instead of EclipticLongitude)
            if (planet === 'Sun') {
                const sunPos = Astronomy.SunPosition(testDate);
                ecliptic = sunPos.elon; // ecliptic longitude
            } else {
                ecliptic = Astronomy.EclipticLongitude(planet, testDate);
            }
            
            const zodiacInfo = getZodiacSign(ecliptic);
            
            console.log(`${getAstronomicalSymbol(planet)} ${planet}:`);
            console.log(`   Longitude: ${ecliptic.toFixed(2)}°`);
            console.log(`   Sign: ${zodiacInfo.emoji} ${zodiacInfo.sign}`);
            console.log(`   Degree: ${zodiacInfo.degree.toFixed(1)}°`);
            console.log(`   Element: ${zodiacInfo.element}`);
            console.log('');
            
        } catch (error) {
            console.error(`❌ Error calculating ${planet}:`, error.message);
        }
    });
}

/**
 * Test moon phase calculations
 */
function testMoonPhaseCalculations() {
    console.log('🌙 Testing Moon Phase Calculations:');
    console.log('===================================');
    
    const testDate = new Date('2025-07-13T12:00:00Z');
    
    try {
        const illumination = Astronomy.Illumination('Moon', testDate);
        const moonLongitude = Astronomy.EclipticLongitude('Moon', testDate);
        const sunPos = Astronomy.SunPosition(testDate);
        const sunLongitude = sunPos.elon;
        
        let phaseAngle = moonLongitude - sunLongitude;
        if (phaseAngle < 0) phaseAngle += 360;
        
        const phaseInfo = getMoonPhaseInfo(phaseAngle);
        const zodiacInfo = getZodiacSign(moonLongitude);
        
        console.log(`🌙 Moon Phase: ${phaseInfo.emoji} ${phaseInfo.name}`);
        console.log(`   Illumination: ${(illumination.phase_fraction * 100).toFixed(1)}%`);
        console.log(`   Phase Angle: ${phaseAngle.toFixed(1)}°`);
        console.log(`   Moon Sign: ${zodiacInfo.emoji} ${zodiacInfo.sign}`);
        console.log(`   Spiritual Meaning: ${phaseInfo.spiritualMeaning}`);
        console.log(`   Sacred Number: ${phaseInfo.sacredNumber}`);
        console.log('');
        
    } catch (error) {
        console.error('❌ Error calculating moon phase:', error.message);
    }
}

/**
 * Test complete cosmic data generation
 */
function testCosmicDataGeneration() {
    console.log('🌌 Testing Complete Cosmic Data Generation:');
    console.log('==========================================');
    
    const testDate = new Date('2025-07-13T12:00:00Z');
    const cosmicData = generateTestCosmicData(testDate);
    
    console.log('📊 Generated Cosmic Data:');
    console.log(JSON.stringify(cosmicData, null, 2));
}

/**
 * Simplified cosmic data generation for testing
 */
function generateTestCosmicData(date) {
    const planets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
    const cosmicData = {
        date: date.toISOString().split('T')[0],
        timestamp: date.toISOString(),
        planets: {},
        moonPhase: {},
        spiritualGuidance: '',
        sacredNumbers: {}
    };
    
    // Calculate planetary positions
    for (const planet of planets) {
        try {
            let ecliptic;
            
            // Special handling for Sun
            if (planet === 'Sun') {
                const sunPos = Astronomy.SunPosition(date);
                ecliptic = sunPos.elon;
            } else {
                ecliptic = Astronomy.EclipticLongitude(planet, date);
            }
            
            const zodiacInfo = getZodiacSign(ecliptic);
            
            cosmicData.planets[planet] = {
                longitude: ecliptic,
                zodiacSign: zodiacInfo.sign,
                zodiacDegree: zodiacInfo.degree,
                element: zodiacInfo.element,
                emoji: zodiacInfo.emoji
            };
            
        } catch (error) {
            cosmicData.planets[planet] = { error: error.message };
        }
    }
    
    // Calculate moon phase
    try {
        const illumination = Astronomy.Illumination('Moon', date);
        const moonLongitude = Astronomy.EclipticLongitude('Moon', date);
        const sunPos = Astronomy.SunPosition(date);
        const sunLongitude = sunPos.elon;
        
        let phaseAngle = moonLongitude - sunLongitude;
        if (phaseAngle < 0) phaseAngle += 360;
        
        const phaseInfo = getMoonPhaseInfo(phaseAngle);
        const zodiacInfo = getZodiacSign(moonLongitude);
        
        cosmicData.moonPhase = {
            illumination: illumination.phase_fraction * 100,
            phaseAngle: phaseAngle,
            phaseName: phaseInfo.name,
            emoji: phaseInfo.emoji,
            zodiacSign: zodiacInfo.sign,
            spiritualMeaning: phaseInfo.spiritualMeaning,
            sacredNumber: phaseInfo.sacredNumber
        };
        
    } catch (error) {
        cosmicData.moonPhase = { error: error.message };
    }
    
    // Generate spiritual guidance
    cosmicData.spiritualGuidance = generateTestSpiritualGuidance(cosmicData);
    
    return cosmicData;
}

function generateTestSpiritualGuidance(cosmicData) {
    const sun = cosmicData.planets.Sun;
    const moon = cosmicData.moonPhase;
    
    if (!sun || !moon || sun.error || moon.error || !moon.spiritualMeaning) {
        return 'The cosmos invites you to trust in the divine timing of your journey.';
    }
    
    return `With the Sun in ${sun.element} and the ${moon.phaseName}, this is a time of ${moon.spiritualMeaning.toLowerCase()}.`;
}

// Helper functions (copied from main function)
function getZodiacSign(longitude) {
    let normalizedLong = longitude % 360;
    if (normalizedLong < 0) normalizedLong += 360;
    
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
    
    return phases[0];
}

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

// Run all tests
testAstronomicalCalculations();
testMoonPhaseCalculations();
testCosmicDataGeneration();

console.log('✅ Cosmic Functions Test Complete!\n');