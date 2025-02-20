var exec = require('cordova/exec');

var TakPlugin = { 
    TakReturnCode : {
        SUCCESS: 0,                         // 0x00000000
        RE_REGISTER_SUCCESS: 2,             // 0x00000002
        GENERAL_ERROR: 983041,              // 0x000F0001
        INVALID_PARAMETER: 983043,          // 0x000F0003
        INVALID_EXECUTION_THREAD: 983044,   // 0x000F0004
        INVALID_SERVER_RESPONSE: 983045,    // 0x000F0005
        NOT_AVAILABLE: 1048575,             // 0x000FFFFF
        ALREADY_INITIALIZED: 65537,         // 0x00010001
        NOT_INITIALIZED: 65538,             // 0x00010002
        DEVICE_VALIDATION_FAILED: 131074,   // 0x00020002
        DEVICE_UPDATE_FAILED: 131075,       // 0x00020003
        DEVICE_NO_FINGERPRINT: 131077,      // 0x00020005
        LICENSE_EXPIRED: 131078,            // 0x00020006
        LICENSE_ABOUT_TO_EXPIRE: 131079,    // 0x00020007
        CLIENT_CERTIFICATE_EXPIRED: 131080, // 0x00020008
        ALREADY_REGISTERED: 131081,         // 0x00020009
        NOT_REGISTERED: 131082,             // 0x0002000A
        INSTANCE_WIPED: 131083,             // 0x0002000B
        INSTANCE_LOCKED: 131084,            // 0x0002000C
        SECURITY_CERTIFICATE_ERROR: 196614, // 0x00030006
        NETWORK_TIMEOUT: 196616,            // 0x00030008
        NETWORK_ERROR: 196617,              // 0x00030009
        STORAGE_NOT_FOUND: 327682,          // 0x00050002
        STORAGE_KEY_NOT_FOUND: 327683,      // 0x00050003
        STORAGE_ALREADY_EXISTS: 327684,     // 0x00050004
        STORAGE_DEVICE_MISMATCH: 327685     // 0x00050005
    },
    // Levels of root
    RootStatus: {
        NOT_ROOTED: 0,
        MAYBE_ROOTED: 1,
        LIKELY_ROOTED: 2,
        ROOTED: 3
    },
    // Initializes TAK
    // [in] string licenseName: license name
    // [returns] true if initialization is successful, false otherwise
    initialize: function(licenseName) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'initialize', [licenseName]);
        });
    },
    // Indicates if the instance has been registered
    // [returns] true if registered, false otherwise
    isRegistered: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'isRegistered', []);
        });
    },
    // Registers the instance
    // [in] string? userHash: user hash, can be null
    // [returns] RegistrationResponse object
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    register: function(userHash) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'register', [userHash]);
        });
    },
    // Checks the integrity of the instance
    // [in] string? safetyNetAttestation: safety net attestation, can be null
    // [returns] CheckIntegrityResponse object
    //          - bool didReRegister: true if a re-registration happened, false otherwise
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    checkIntegrity: function(safetyNetAttestation) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'checkIntegrity', [safetyNetAttestation]);
        });
    },
    // Releases TAK
    // [returns] true if released, false otherwise
    release: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'release', []);
        });
    },
    // Indicates if the device is rooted/jailbroken
    // [returns] true if rooted/jailbroken, false otherwise
    isRooted: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'isRooted', []);
        });
    },
    // Indicates the root level of the device
    // [returns] level of root (NOT_ROOTED, MAYBE_ROOTED, LIKELY_ROOTED, ROOTED)
    getAdvancedRootStatus: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'getAdvancedRootStatus', []);
        });
    },
    // Decrypts data using fileProtectot
    // [in] string encryptedData: data
    // [returns] decrypted bytes in hex format
    fileProtectorDecryptData: function(encryptedData) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'fileProtectorDecryptData', [encryptedData]);
        });
    },
    // Decrypts a file
    // [in] string fileName: file name
    // [returns] decrypted bytes in hex format
    fileProtectorDecryptFile: function(fileName) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'fileProtectorDecryptFile', [fileName]);
        });
    },
    // Encrypts data using fileProtector
    // [in] string decryptedData: data to encrypt in hex
    // [returns] encrypted bytes in hex format
    fileProtectorEncryptData: function(decryptedData) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'fileProtectorEncryptData', [decryptedData]);
        });
    },
    // Writes a string value to a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [in] string value: data to store
    // [returns] true if creation is successful, false otherwise
    secureStorageWrite: function(storageName, key, value) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'secureStorageWrite', [storageName, key, value]);
        });
    },
    // Reads a string value from a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [returns] string value identified by the key
    secureStorageRead: function(storageName, key) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'secureStorageRead', [storageName, key]);
        });
    },
    // Deletes a secure storage
    // [in] string storageName: secure storage name
    // [returns] true if deletion is successful, false otherwise
    deleteSecureStorage: function(storageName) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'deleteSecureStorage', [storageName]);
        });
    },
    // Deletes an entry from a secure storage
    // [in] string storageName: secure storage name
    // [in] string key: data key
    // [returns] true if entry deletion is successful, false otherwise
    secureStorageDeleteEntry: function(storageName, key) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'secureStorageDeleteEntry', [storageName, key]);
        });
    },
    // Resets TAK
    // [returns] true if reset is successful, false otherwise
    reset: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'reset', []);
        });
    },
    // Generates random bytes
    // [in] int numBytes: number of bytes to generate
    // [returns] hex string of generated bytes
    generateRandom: function(numBytes) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'generateRandom', [numBytes]);
        });
    },
    // Returns the software version of the TAK Client library
    // [returns] TAK library version
    getVersion: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'getVersion', []);
        });
    },
    // Returns the build version of the T.A.K Client library
    // [returns] TAK build version
    getBuildNumber: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'getBuildNumber', []);
        });
    },
    // Returns the TAK id
    // [returns] Tak id
    getTakIdentifier: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'getTakIdentifier', []);
        });
    },
    // Creates a background thread hat launches runtime checks.
    // [in] int timeInterval: interval in seconds to repeat the thread's execution
    // [returns] true if creation is successful, false otherwise
    createRuntimeCheckThread: function(timeInterval) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'createRuntimeCheckThread', [timeInterval]);
        });
    },
    // Checks if runtime checks' thread is running.
    // [in] bool relaunch: relaunch the thread, if not active
    // [returns] true if the thread is running, false otherwise
    isRuntimeThreadActive: function(relaunch) {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'isRuntimeThreadActive', [relaunch]);
        });
    },
    // Stops runtime checks' thread if running.
    // [returns] true if the thread has been stopped, false otherwise
    stopRuntimeThread: function() {
        return new Promise((resolve, reject) => {
            exec(resolve, reject, 'TakPlugin', 'stopRuntimeThread', []);
        });
    },
};

module.exports = TakPlugin;
