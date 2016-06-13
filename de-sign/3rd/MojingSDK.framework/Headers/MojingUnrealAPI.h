#pragma once


#if PLATFORM_ANDROID
#include <android/input.h>
#include <android/keycodes.h>
bool Unreal_NativePreDispatchKeyEvent(AInputEvent* event, int& iDevice, int& iKeyCode, bool &bDown);
int Unreal_NativePreDispatchMotionEvent(AInputEvent* event, int iMaxAxisCount, int& iDevice, int* iAxis, float* fValue);
#else
bool Unreal_Init(const char* szMerchantID, const char* szAppID, const char* szAppKey, const char* szChannelID);
bool Unreal_StartTracker(int nSampleFrequence);
void Unreal_StopTracker(void);
#endif

bool Unreal_SetEngineVersion(const char* lpszEngine);

// API for tracking head
int Unreal_CheckSensors();
void Unreal_ResetSensorOrientation(void);
void Unreal_ResetTracker(void);
int Unreal_StartTrackerCalibration();
float Unreal_IsTrackerCalibrated();
void Unreal_getLastHeadView(float* pfViewMatrix);
void Unreal_getLastHeadEulerAngles(float* pfEulerAngles);
void Unreal_getLastHeadQuarternion(float &w, float &x, float &y, float &z);

// API for distortion
bool Unreal_EnterMojingWorld(const char * szGlassesName);
bool Unreal_ChangeMojingWorld(const char * szGlassesName);
bool Unreal_LeaveMojingWorld();
int Unreal_GetMojingWorldDistortionMesh(int iWidthCells, int iHeightCells, void * pVerts, void * pIndices);
float Unreal_GetFOV();
float Unreal_GetGlassesSeparation();
float Unreal_GetGlassesSeparationInPix();
bool Unreal_DistortionSetLensSeparation(float fNewValue);
float Unreal_DistortionGetLensSeparation();
const char* Unreal_GetDefaultMojingWorld(const char* strLanguageCodeByISO639);
const char* Unreal_GetLastMojingWorld(const char* strLanguageCodeByISO639);

// API for get glass info
void Unreal_FreeString(char * pReleaseString);
const char* Unreal_GetManufacturerList(const char* strLanguageCodeByISO639);
const char* Unreal_GetProductList(const char* strManufacturerKey, const char* strLanguageCodeByISO639);
const char* Unreal_GetGlassList(const char* strProductKey, const char* strLanguageCodeByISO639);
const char* Unreal_GetGlassInfo(const char* strGlassKey, const char* strLanguageCodeByISO639);
const char* Unreal_GenerationGlassKey(const char* strProductQRCode, const char* strGlassQRCode);

// API for get SDK status
bool Unreal_GetInitSDK(void);
bool Unreal_GetStartTracker(void);
bool Unreal_GetInMojingWorld(void);
const char* Unreal_GetSDKVersion(void);
bool Unreal_IsGlassesNeedDistortion(void);

//API for report
void Unreal_AppSetContinueInterval(int interval);
void Unreal_AppPageStart(const char* szPageName);
void Unreal_AppPageEnd(const char* szPageName);
void Unreal_AppSetEvent(const char* szEventName, const char* szEventChannelID, const char* szEventInName, float eInData, const char* szEventOutName, float eOutData);
void Unreal_ReportLog(int iLogType, const char* szTypeName, const char* szLogContent);