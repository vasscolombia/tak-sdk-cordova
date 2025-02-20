package com.build38.tak;

import android.util.Log;

import com.build38.tak.CheckIntegrityResponse;
import com.build38.tak.EncryptionOutput;
import com.build38.tak.FileProtector;
import com.build38.tak.RegisterResponse;
import com.build38.tak.SecureStorage;
import com.build38.tak.TAK;
import com.build38.tak.TakException;
import com.build38.tak.TakReturnCode;
import com.build38.tak.WrappedKey;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TakPlugin extends CordovaPlugin {
    private TAK tak;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("initialize")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(initialize(args));
                }
            });
            return true;
        }
        else if (action.equals("isRegistered")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(isRegistered(args));
                }
            });
            return true;
        }
        else if (action.equals("register")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(register(args));
                }
            });
            return true;
        }
        else if (action.equals("checkIntegrity")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(checkIntegrity(args));
                }
            });
            return true;
        }
        else if (action.equals("release")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(release(args));
                }
            });
            return true;
        }
        else if (action.equals("isRooted")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(isRooted(args));
                }
            });
            return true;
        }
        else if (action.equals("getAdvancedRootStatus")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(getAdvancedRootStatus(args));
                }
            });
            return true;
        }
        else if (action.equals("fileProtectorDecryptData")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(fileProtectorDecryptData(args));
                }
            });
            return true;
        }
        else if (action.equals("fileProtectorDecryptFile")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(fileProtectorDecryptFile(args));
                }
            });
            return true;
        }
        else if (action.equals("fileProtectorEncryptData")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(fileProtectorEncryptData(args));
                }
            });
            return true;
        }
        else if (action.equals("secureStorageWrite")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(secureStorageWrite(args));
                }
            });
            return true;
        }
        else if (action.equals("secureStorageRead")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(secureStorageRead(args));
                }
            });
            return true;
        }
        else if (action.equals("deleteSecureStorage")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(deleteSecureStorage(args));
                }
            });
            return true;
        }
        else if (action.equals("secureStorageDeleteEntry")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(secureStorageDeleteEntry(args));
                }
            });
            return true;
        }
        else if (action.equals("reset")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(reset(args));
                }
            });
            return true;
        }
        else if (action.equals("generateRandom")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(generateRandom(args));
                }
            });
            return true;
        }
        else if (action.equals("getVersion")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(getVersion(args));
                }
            });
            return true;
        }
        else if (action.equals("getBuildNumber")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(getBuildNumber(args));
                }
            });
            return true;
        }
        else if (action.equals("getTakIdentifier")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(getTakIdentifier(args));
                }
            });
            return true;
        }
        else if (action.equals("createRuntimeCheckThread")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(createRuntimeCheckThread(args));
                }
            });
            return true;
        }
        else if (action.equals("isRuntimeThreadActive")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(isRuntimeThreadActive(args));
                }
            });
            return true;
        }
        else if (action.equals("stopRuntimeThread")) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    callbackContext.sendPluginResult(stopRuntimeThread(args));
                }
            });
            return true;
        }
        return false;
    }

    // Initializes TAK
    // [in] string licenseName: license name
    // [returns] true if initialization is successful, false otherwise
    private PluginResult initialize(JSONArray args) {
        try {
            String license = args.getString(0);
            if (args.isNull(0) || license.isEmpty() || !(args.get(0) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);


            tak = new TAK(this.cordova.getActivity(), license);
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "initialize error: " + exception);
        }
    }

    // Indicates if the instance has been registered
    // [returns] true if registered, false otherwise
    private PluginResult isRegistered(JSONArray args) {        
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);
            boolean isRegistered = tak.isRegistered();
            return new PluginResult(PluginResult.Status.OK, isRegistered);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "isRegistered error: " + exception);
        }
    }

    // Registers the instance
    // [in] string? userHash: user hash, can be null
    // [returns] RegistrationResponse object
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    private PluginResult register(JSONArray args) {        
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);
            String userHash = null;
            if (!args.isNull(0)) {
                if (!(args.get(0) instanceof String) || args.getString(0).isEmpty()) throw new TakException(TakReturnCode.INVALID_PARAMETER);
                userHash = args.getString(0);
            }
            
            RegisterResponse registerResponse = tak.register(userHash);
            JSONObject returnObject = new JSONObject();
            returnObject.put("takId", registerResponse.getTakId());
            returnObject.put("isLicenseAboutToExpire", registerResponse.isLicenseAboutToExpire());
            return new PluginResult(PluginResult.Status.OK, returnObject);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "register error: " + exception);
        }
    }

    // Checks the integrity of the instance
    // [in] string? safetyNetAttestation: safety net attestation, can be null
    // [returns] CheckIntegrityResponse object
    //          - bool didReRegister: true if a re-registration happened, false otherwise
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    private PluginResult checkIntegrity(JSONArray args) {        
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String safetyNetAttestation = null;
            if (!args.isNull(0)) {
                if (!(args.get(0) instanceof String) || args.getString(0).isEmpty()) throw new TakException(TakReturnCode.INVALID_PARAMETER);
                safetyNetAttestation = args.getString(0);
            }

            CheckIntegrityResponse checkIntegrityResponse = tak.checkIntegrity(safetyNetAttestation);
            JSONObject returnObject = new JSONObject();
            returnObject.put("takId", checkIntegrityResponse.getTakId());
            returnObject.put("isLicenseAboutToExpire", checkIntegrityResponse.isLicenseAboutToExpire());
            returnObject.put("didReRegister", checkIntegrityResponse.getDidReRegister());
            return new PluginResult(PluginResult.Status.OK, returnObject);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "checkIntegrity error: " + exception);
        }
    }

    // Releases TAK
    // [returns] true if released, false otherwise
    private PluginResult release(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            tak.release();
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "release error: " + exception);
        }
    }

    // Indicates if the device is rooted/jailbroken
    // [returns] true if rooted/jailbroken, false otherwise
    private PluginResult isRooted(JSONArray args) {
        try {
            if (tak == null || !tak.isInitialized()) throw new TakException(TakReturnCode.NOT_INITIALIZED);
            boolean isRooted = tak.isRooted();
            return new PluginResult(PluginResult.Status.OK, isRooted);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "isRooted error: " + exception);
        }
    }

    // Indicates the root level of the device
    // [returns] level of root (NOT_ROOTED, MAYBE_ROOTED, LIKELY_ROOTED, ROOTED)
    private PluginResult getAdvancedRootStatus(JSONArray args) {
        try {
            if (tak == null || !tak.isInitialized()) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            RootStatus status = tak.getAdvancedRootStatus();
            return new PluginResult(PluginResult.Status.OK, status.ordinal());
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "getAdvancedRootStatus error: " + exception);
        }
    }

    // Decrypts data using fileProtectot
    // [in] string encryptedData: data
    // [returns] decrypted bytes in hex format
    private PluginResult fileProtectorDecryptData(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String fileData = args.getString(0);
            if (args.isNull(0) || fileData.isEmpty() || !(args.get(0) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            byte[] byteArray = decodeHexString(fileData);
            byte[] decryptedData = tak.getFileProtector().decrypt(byteArray);
            String data = new String(decryptedData);
            return new PluginResult(PluginResult.Status.OK, data);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "fileProtectorDecryptData error: " + exception);
        }
    }

    // Decrypts a file
    // [in] string fileName: file name
    // [returns] decrypted bytes in hex format
    private PluginResult fileProtectorDecryptFile(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String fileName = args.getString(0);
            if (args.isNull(0) || fileName.isEmpty() || !(args.get(0) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            byte[] decryptedData = tak.getFileProtector().decrypt(fileName);
            String data = new String(decryptedData);
            return new PluginResult(PluginResult.Status.OK, data);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "fileProtectorDecryptFile error: " + exception);
        }
    }

    // Encrypts data using fileProtector
    // [in] string decryptedData: data to encrypt in hex
    // [returns] encrypted bytes in hex format
    private PluginResult fileProtectorEncryptData(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String decryptedData = args.getString(0);
            if (args.isNull(0) || decryptedData.isEmpty() || !(args.get(0) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            byte[] byteArray = decryptedData.getBytes();
            byte[] encryptedData = tak.getFileProtector().encrypt(byteArray);
            String data = toHexString(encryptedData);
            return new PluginResult(PluginResult.Status.OK, data);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "fileProtectorEncryptData error: " + exception);
        }
    }

    // Writes a string value to a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [in] string value: data to store
    // [returns] true if creation is successful, false otherwise
    private PluginResult secureStorageWrite(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String storageName = args.getString(0);
            String key = args.getString(1);
            String value = args.getString(2);
            if (args.isNull(0) || args.isNull(1) || args.isNull(2) || storageName.isEmpty() || key.isEmpty() || value.isEmpty() || !(args.get(0) instanceof String) || !(args.get(1) instanceof String) || !(args.get(2) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            tak.getSecureStorage(storageName).write(key, value, StandardCharsets.UTF_8);
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "secureStorageWrite error: " + exception);
        }
    }

    // Reads a string value from a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [returns] string value identified by the key
    private PluginResult secureStorageRead(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String storageName = args.getString(0);
            String key = args.getString(1);
            if (args.isNull(0) || args.isNull(1) || storageName.isEmpty() || key.isEmpty() || !(args.get(0) instanceof String) || !(args.get(1) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            String value = tak.getSecureStorage(storageName).readString(key, null, StandardCharsets.UTF_8);
            return new PluginResult(PluginResult.Status.OK, value);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "secureStorageRead error: " + exception);
        }
    }

    // Deletes a secure storage
    // [in] string storageName: secure storage name
    // [returns] true if deletion is successful, false otherwise
    private PluginResult deleteSecureStorage(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String storageName = args.getString(0);
            if (args.isNull(0) || storageName.isEmpty() || !(args.get(0) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            tak.getSecureStorage(storageName).delete();
            return new PluginResult(PluginResult.Status.OK, 0);
        }
        catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        }
        catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "deleteSecureStorage error: " + exception);
        }
    }

    // Deletes an entry from a secure storage
    // [in] string storageName: secure storage name
    // [in] string key: data key
    // [returns] true if entry deletion is successful, false otherwise
    private PluginResult secureStorageDeleteEntry(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String storageName = args.getString(0);
            String key = args.getString(1);
            if (args.isNull(0) || args.isNull(1) || storageName.isEmpty() || key.isEmpty() || !(args.get(0) instanceof String) || !(args.get(1) instanceof String)) throw new TakException(TakReturnCode.INVALID_PARAMETER);

            tak.getSecureStorage(storageName).deleteEntry(key);
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "secureStorageDeleteEntry error: " + exception);
        }
    }

    // Resets TAK
    // [returns] true if reset is successful, false otherwise
    private PluginResult reset(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            tak.reset();
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "reset error: " + exception);
        }
    }

    // Generates random bytes
    // [in] int numBytes: number of bytes to generate
    // [returns] hex string of generated bytes
    private PluginResult generateRandom(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            if (args.isNull(0) || !(args.get(0) instanceof Integer)) throw new TakException(TakReturnCode.INVALID_PARAMETER);
            int numBytes = args.getInt(0);

            byte[] generatedBytes = tak.generateRandom(numBytes);
            String generatedHex = toHexString(generatedBytes);
            return new PluginResult(PluginResult.Status.OK, generatedHex);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "secureStorageRead error: " + exception);
        }
    }


    // Returns the software version of the TAK Client library
    // [returns] TAK library version
    private PluginResult getVersion(JSONArray args) {
        try {
            if (tak == null || !tak.isInitialized()) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String version = tak.getVersion();
            return new PluginResult(PluginResult.Status.OK, version);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "getVersion error: " + exception);
        }
    }

    // Returns the build version of the T.A.K Client library
    // [returns] TAK build version
    private PluginResult getBuildNumber(JSONArray args) {
        try {
            if (tak == null || !tak.isInitialized()) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String buildNumber = tak.getBuildNumber();
            return new PluginResult(PluginResult.Status.OK, buildNumber);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "getBuildNumber error: " + exception);
        }
    }

    // Returns the TAK id
    // [returns] Tak id
    private PluginResult getTakIdentifier(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            String takId = tak.getTakIdentifier();
            return new PluginResult(PluginResult.Status.OK, takId);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "getTakIdentifier error: " + exception);
        }
    }

    // Creates a background thread hat launches runtime checks.
    // [in] int timeInterval: interval in seconds to repeat the thread's execution
    // [returns] true if creation is successful, false otherwise
    private PluginResult createRuntimeCheckThread(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            if (args.isNull(0) || !(args.get(0) instanceof Integer)) throw new TakException(TakReturnCode.INVALID_PARAMETER);
            int timeInterval = args.getInt(0);
                
            tak.createRuntimeCheckThread(timeInterval);
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "createRuntimeCheckThread error: " + exception);
        }
    }

    // Checks if runtime checks' thread is running.
    // [in] bool relaunch: relaunch the thread, if not active
    // [returns] true if the thread is running, false otherwise
    private PluginResult isRuntimeThreadActive(JSONArray args) {
        try {
            if (tak == null || !tak.isInitialized()) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            if (args.isNull(0) || !(args.get(0) instanceof Boolean)) throw new TakException(TakReturnCode.INVALID_PARAMETER);
            boolean relaunch = args.getBoolean(0);
                    
            boolean isActive = tak.isRuntimeThreadActive(relaunch);
            return new PluginResult(PluginResult.Status.OK, isActive);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "isRuntimeThreadActive error: " + exception);
        }
    }

    // Stops runtime checks' thread if running.
    // [returns] true if the thread has been stopped, false otherwise
    private PluginResult stopRuntimeThread(JSONArray args) {
        try {
            if (tak == null) throw new TakException(TakReturnCode.NOT_INITIALIZED);

            tak.stopRuntimeThread();
            return new PluginResult(PluginResult.Status.OK, 0);
        } catch (TakException exception) {
            return new PluginResult(PluginResult.Status.ERROR, exception.getReason().getValue());
        } catch (Exception exception) {
            return new PluginResult(PluginResult.Status.ERROR, "stopRuntimeThread error: " + exception);
        }
    }

    public static String toHexString(byte[] byteArray) {
        StringBuilder sb = new StringBuilder();
        for (byte b : byteArray) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public byte hexToByte(String hexString) throws TakException {
        int firstDigit = toDigit(hexString.charAt(0));
        int secondDigit = toDigit(hexString.charAt(1));
        return (byte) ((firstDigit << 4) + secondDigit);
    }

    private int toDigit(char hexChar) throws TakException {
        int digit = Character.digit(hexChar, 16);
        if(digit == -1) {
            throw new TakException(TakReturnCode.INVALID_PARAMETER);
        }
        return digit;
    }

    public byte[] decodeHexString(String hexString) throws TakException {
        if (hexString.length() % 2 == 1) {
            throw new TakException(TakReturnCode.INVALID_PARAMETER);
        }

        byte[] bytes = new byte[hexString.length() / 2];
        for (int i = 0; i < hexString.length(); i += 2) {
            bytes[i / 2] = hexToByte(hexString.substring(i, i + 2));
        }
        return bytes;
    }
}
