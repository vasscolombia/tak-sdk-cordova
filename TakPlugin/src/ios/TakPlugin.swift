//
//  TakPlugin.swift
//  App
//
//  Created by Bernat Borràs Civil on 24/5/24.
//

import Foundation
import TAK
import TakTls

@objc(TakPlugin)
public  class TakPlugin: CDVPlugin {
    
    private var tak: TAK? = nil;

    // Initializes TAK
    // [in] string licenseName: license name
    // [returns] true if initialization is successful, false otherwise
    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard let licenseName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }
                
                self.tak = try TAK(licenseFileName: licenseName)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "initialize error: \(error)")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Indicates if the instance has been registered
    // [returns] true if registered, false otherwise
    @objc(isRegistered:)
    func isRegistered(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }
                
                let isRegistered = try self.tak!.isRegistered()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isRegistered)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)     
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Registers the instance
    // [in] string? userHash: user hash, can be null
    // [returns] RegistrationResponse object
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    @objc(register:)
    func register(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }
            
                var userHash: String? = nil;
                if (!(command.arguments[0] is NSNull)) {
                    guard let hash = command.arguments[0] as? String else {
                        throw TakError.invalidParameter
                    }
                    userHash = hash
                }

                let registrationResponse = try self.tak!.register(userHash: userHash)
                let responseDictionary = [
                    "takId" : registrationResponse.takIdentifier,
                    "isLicenseAboutToExpire" : registrationResponse.isLicenseAboutToExpire
                ]
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: responseDictionary)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "register error: \(error)")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }


    // Checks the integrity of the instance
    // [in] string? safetyNetAttestation: safety net attestation, can be null
    // [returns] CheckIntegrityResponse object
    //          - bool didReRegister: true if a re-registration happened, false otherwise
    //          - bool isLicenseAboutToExpire: true if license is about to expire, false otherwise
    //          - string takId: TAK id
    @objc(checkIntegrity:)
    func checkIntegrity(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                let checkIntegrityResponse = try self.tak!.checkIntegrity()
                let responseDictionary = [
                    "takId" : checkIntegrityResponse.takIdentifier,
                    "isLicenseAboutToExpire" : checkIntegrityResponse.isLicenseAboutToExpire,
                    "didReRegister" : checkIntegrityResponse.didReregister
                ]
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: responseDictionary)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Releases TAK
    // [returns] true if released, false otherwise
    @objc(release:)
    func release(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                try self.tak!.release()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Indicates if the device is rooted/jailbroken
    // [returns] true if rooted/jailbroken, false otherwise
    @objc(isRooted:)
    func isRooted(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                let isJailbroken = try self.tak!.isJailbroken()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isJailbroken)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)     
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Indicates the root level of the device
    // [returns] level of root (NOT_ROOTED, MAYBE_ROOTED, LIKELY_ROOTED, ROOTED)
    @objc(getAdvancedRootStatus:)
    func getAdvancedRootStatus(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                let jailbreakLevel = try self.tak!.getAdvancedJailbreakStatus()!
                let enumValues: [JailbreakStatus] = [.notJailbroken, .maybeJailbroken, .likelyJailbroken, .jailbroken]
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: enumValues.firstIndex(of: jailbreakLevel)!)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Decrypts data using fileProtectot
    // [in] string data: data
    // [returns] decrypted bytes in hex format
    @objc(fileProtectorDecryptData:)
    func fileProtectorDecryptData(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let fileData = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                let data = try hexToByte(hex: fileData)!
                let decryptedData = try self.tak!.getFileProtector().decrypt(encryptedData: data)
                let value = String(decoding: decryptedData, as: UTF8.self)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: value)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Decrypts a file
    // [in] string fileName: file name
    // [returns] decrypted bytes in hex format
    @objc(fileProtectorDecryptFile:)
    func fileProtectorDecryptFile(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let fileName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                let decryptedData = try self.tak!.getFileProtector().decrypt(fromFileNamed: fileName)
                let value = String(decoding: decryptedData, as: UTF8.self)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: value)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }
    
    // Encrypts data using fileProtector
    // [in] string decryptedData: data to encrypt in hex
    // [returns] encrypted bytes in hex format
    @objc(fileProtectorEncryptData:)
    func fileProtectorEncryptData(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in            
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let fileData = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                let data = Data(fileData.utf8)
                let encryptedData = try self.tak!.getFileProtector().encrypt(plainData: data)
                let value = toHex(data: encryptedData)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: value)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Writes a string value to a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [in] string value: data to store
    // [returns] true if creation is successful, false otherwise
    @objc(secureStorageWrite:)
    func secureStorageWrite(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let storageName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                guard let key = command.arguments[1] as? String else {
                    throw TakError.invalidParameter
                }

                guard let value = command.arguments[2] as? String else {
                    throw TakError.invalidParameter
                }

                try self.tak!.getSecureStorage(storageName: storageName).write(key: key, value: value)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Reads a string value from a secure storage
    // [in] string storageName: secure storage name to store
    // [in] string key: data key
    // [returns] string value identified by the key
    @objc(secureStorageRead:)
    func secureStorageRead(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let storageName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                guard let key = command.arguments[1] as? String else {
                    throw TakError.invalidParameter
                }

                let value: String = try self.tak!.getSecureStorage(storageName: storageName).read(key: key)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: value)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Deletes a secure storage
    // [in] string storageName: secure storage name
    // [returns] true if deletion is successful, false otherwise
    @objc(deleteSecureStorage:)
    func deleteSecureStorage(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let storageName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                try self.tak!.getSecureStorage(storageName: storageName).delete()

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Deletes an entry from a secure storage
    // [in] string storageName: secure storage name
    // [in] string key: data key
    // [returns] true if entry deletion is successful, false otherwise
    @objc(secureStorageDeleteEntry:)
    func secureStorageDeleteEntry(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let storageName = command.arguments[0] as? String else {
                    throw TakError.invalidParameter
                }

                guard let key = command.arguments[1] as? String else {
                    throw TakError.invalidParameter
                }

                guard key != "" else {
                    throw TakError.invalidParameter
                }

                try self.tak!.getSecureStorage(storageName: storageName).deleteEntry(key: key)

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Resets TAK
    // [returns] true if reset is successful, false otherwise
    @objc(reset:)
    func reset(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }
                
                try self.tak!.reset()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Generates random bytes
    // [in] int numBytes: number of bytes to generate
    // [returns] hex string of generated bytes
    @objc(generateRandom:)
    func generateRandom(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let numBytes = command.arguments[0] as? Int32 else {
                    throw TakError.invalidParameter
                }

                let generatedBytes = try self.tak!.generateRandom(numBytes: numBytes)
                let generatedHex = toHex(data: generatedBytes)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: generatedHex)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Returns the software version of the TAK Client library
    // [returns] TAK library version
    @objc(getVersion:)
    func getVersion(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                let version = try self.tak!.getTakVersion()

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: version)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Returns the build version of the T.A.K Client library
    // [returns] TAK build version
    @objc(getBuildNumber:)
    func getBuildNumber(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                let buildNumber = try self.tak!.getTakBuildNumber()

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: buildNumber)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Returns the TAK id
    // [returns] Tak id
    @objc(getTakIdentifier:)
    func getTakIdentifier(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                let takId = try self.tak!.getTakIdentifier()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: takId)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Creates a background thread hat launches runtime checks.
    // [in] int timeInterval: interval in seconds to repeat the thread's execution
    // [returns] true if creation is successful, false otherwise
    @objc(createRuntimeCheckThread:)
    func createRuntimeCheckThread(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil else {
                    throw TakError.notInitialized
                }

                guard let timeInterval = command.arguments[0] as? Int32 else {
                    throw TakError.invalidParameter
                }

                try self.tak!.createRuntimeCheckThread(timeInterval: timeInterval)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }

    // Checks if runtime checks' thread is running.
    // [in] bool relaunch: relaunch the thread, if not active
    // [returns] true if the thread is running, false otherwise
    @objc(isRuntimeThreadActive:)
    func isRuntimeThreadActive(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                guard let relaunch = command.arguments[0] as? Bool else {
                    throw TakError.invalidParameter
                }

                let isActive = try self.tak!.isRuntimeThreadActive(relaunch: relaunch)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isActive)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }
    
    // Stops runtime checks' thread if running.
    // [returns] true if the thread has been stopped, false otherwise
    @objc(stopRuntimeThread:)
    func stopRuntimeThread(command: CDVInvokedUrlCommand) {
        commandDelegate.run(inBackground: { [self] in
            do {
                guard self.tak != nil && self.tak!.isInitialized() else {
                    throw TakError.notInitialized
                }

                try self.tak!.stopRuntimeThread()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 0)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch let error as TakError {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: toInt(error: error))
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
            catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Operation failed")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        })
    }
    
    private func toHex(data: Data) -> String {
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    private func hexToByte(hex: String) throws -> Data? {
        guard hex.count % 2 == 0 else {
            throw TakError.invalidParameter
        }
        var data = Data()
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let hexPair = String(hex[index..<nextIndex])
            if let byte = UInt8(hexPair, radix: 16) {
                data.append(byte)
            } else {
                throw TakError.invalidParameter
            }
            index = nextIndex
        }
        return data
    }
    
    private func toInt(error: TakError) -> Int32 {
        switch error {
        case TakError.invalidParameter:
            return 983043
        case TakError.invalidServerResponse:
            return 983045
        case TakError.notAvailable:
            return 1048575
        case TakError.validationFailed:
            return 131074
        case TakError.updateFailed:
            return 131075
        case TakError.noFingerprint:
            return 131077
        case TakError.licenseExpired:
            return 131078
        case TakError.certificateExpired:
            return 131080
        case TakError.alreadyRegistered:
            return 131081
        case TakError.notRegistered:
            return 131082
        case TakError.instanceWiped:
            return 131083
        case TakError.instanceLocked:
            return 131084
        case TakError.certificateError:
            return 196614
        case TakError.networkTimeout:
            return 196616
        case TakError.networkError:
            return 196617
        case TakError.storageNotFound:
            return 327682
        case TakError.storageKeyNotFound:
            return 327683
        case TakError.storageAlreadyExists:
            return 327684
        case TakError.deviceMismatch:
            return 327685
        case TakError.notInitialized:
            return 65538
        case TakError.general:
            return 983041
        default:
            return 983041
        }
    }
}
