//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __cplusplus
#include <stdbool.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct easyar_Opaque easyar_Opaque;

typedef struct easyar_String easyar_String;
void easyar_String_from_utf8(const char * _Nullable begin, const char * _Nullable end, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_String_from_utf8_begin(const char * _Nonnull begin, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
const char * _Nullable easyar_String_begin(const easyar_String * _Nonnull This);
const char * _Nullable easyar_String_end(const easyar_String * _Nonnull This);
void easyar_String_copy(const easyar_String * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_String__dtor(easyar_String * _Nonnull This);

typedef struct easyar_CloudRecognizer easyar_CloudRecognizer;

typedef struct easyar_Buffer easyar_Buffer;

typedef struct easyar_Drawable easyar_Drawable;

typedef struct easyar_Frame easyar_Frame;

typedef struct easyar_Image easyar_Image;

typedef struct
{
    float data[12];
} easyar_Matrix34F;

typedef struct
{
    float data[16];
} easyar_Matrix44F;

typedef struct
{
    float data[4];
} easyar_Vec4F;

typedef struct
{
    float data[3];
} easyar_Vec3F;

typedef struct
{
    float data[2];
} easyar_Vec2F;

typedef struct
{
    int data[4];
} easyar_Vec4I;

typedef struct
{
    int data[2];
} easyar_Vec2I;

typedef struct easyar_CameraCalibration easyar_CameraCalibration;

typedef struct easyar_CameraDevice easyar_CameraDevice;

typedef struct easyar_VideoPlayer easyar_VideoPlayer;

typedef struct easyar_Renderer easyar_Renderer;

typedef struct easyar_Engine easyar_Engine;

typedef struct easyar_FrameFilter easyar_FrameFilter;

typedef struct easyar_FrameStreamer easyar_FrameStreamer;

typedef struct easyar_CameraFrameStreamer easyar_CameraFrameStreamer;

typedef struct easyar_QRCodeScanner easyar_QRCodeScanner;

typedef struct easyar_Target easyar_Target;

typedef struct easyar_TargetInstance easyar_TargetInstance;

typedef struct easyar_TargetTracker easyar_TargetTracker;

typedef struct easyar_ImageTarget easyar_ImageTarget;

typedef struct easyar_ImageTracker easyar_ImageTracker;

typedef struct easyar_ListOfPointerOfTarget easyar_ListOfPointerOfTarget;

typedef struct easyar_ListOfPointerOfImage easyar_ListOfPointerOfImage;

typedef struct easyar_ListOfPointerOfTargetInstance easyar_ListOfPointerOfTargetInstance;

typedef struct easyar_ListOfPointerOfImageTarget easyar_ListOfPointerOfImageTarget;

typedef struct
{
    easyar_Opaque * _Nonnull _state;
    void (* _Nonnull _func)(easyar_Opaque * _Nonnull _state, int);
    void (* _Nonnull _destroy)(easyar_Opaque * _Nonnull _state);
} easyar_FunctorOfVoidFromCloudStatus;

typedef struct
{
    easyar_Opaque * _Nonnull _state;
    void (* _Nonnull _func)(easyar_Opaque * _Nonnull _state, int, easyar_ListOfPointerOfTarget * _Nonnull);
    void (* _Nonnull _destroy)(easyar_Opaque * _Nonnull _state);
} easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget;

typedef struct
{
    easyar_Opaque * _Nonnull _state;
    void (* _Nonnull _func)(easyar_Opaque * _Nonnull _state, int, easyar_String * _Nonnull);
    void (* _Nonnull _destroy)(easyar_Opaque * _Nonnull _state);
} easyar_FunctorOfVoidFromPermissionStatusAndString;

typedef struct
{
    easyar_Opaque * _Nonnull _state;
    void (* _Nonnull _func)(easyar_Opaque * _Nonnull _state, int);
    void (* _Nonnull _destroy)(easyar_Opaque * _Nonnull _state);
} easyar_FunctorOfVoidFromVideoStatus;

typedef struct
{
    easyar_Opaque * _Nonnull _state;
    void (* _Nonnull _func)(easyar_Opaque * _Nonnull _state, easyar_Target * _Nonnull, bool);
    void (* _Nonnull _destroy)(easyar_Opaque * _Nonnull _state);
} easyar_FunctorOfVoidFromPointerOfTargetAndBool;

void easyar_CloudRecognizer__ctor(/* OUT */ easyar_CloudRecognizer * _Nonnull * _Nonnull Return);
void easyar_CloudRecognizer_open(easyar_CloudRecognizer * _Nonnull This, easyar_String * _Nonnull server, easyar_String * _Nonnull appKey, easyar_String * _Nonnull appSecret, easyar_FunctorOfVoidFromCloudStatus callback_open, easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget callback_recognize);
bool easyar_CloudRecognizer_close(easyar_CloudRecognizer * _Nonnull This);
bool easyar_CloudRecognizer_attachStreamer(easyar_CloudRecognizer * _Nonnull This, easyar_FrameStreamer * _Nullable obj);
bool easyar_CloudRecognizer_start(easyar_CloudRecognizer * _Nonnull This);
bool easyar_CloudRecognizer_stop(easyar_CloudRecognizer * _Nonnull This);
void easyar_CloudRecognizer__dtor(easyar_CloudRecognizer * _Nonnull This);
void easyar_CloudRecognizer__retain(const easyar_CloudRecognizer * _Nonnull This, /* OUT */ easyar_CloudRecognizer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_CloudRecognizer__typeName(const easyar_CloudRecognizer * _Nonnull This);
void easyar_castCloudRecognizerToFrameFilter(const easyar_CloudRecognizer * _Nonnull This, /* OUT */ easyar_FrameFilter * _Nonnull * _Nonnull Return);
void easyar_tryCastFrameFilterToCloudRecognizer(const easyar_FrameFilter * _Nonnull This, /* OUT */ easyar_CloudRecognizer * _Nonnull * _Nonnull Return);

easyar_Opaque * _Nonnull easyar_Buffer_data(const easyar_Buffer * _Nonnull This);
int easyar_Buffer_size(const easyar_Buffer * _Nonnull This);
void easyar_Buffer__dtor(easyar_Buffer * _Nonnull This);
void easyar_Buffer__retain(const easyar_Buffer * _Nonnull This, /* OUT */ easyar_Buffer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Buffer__typeName(const easyar_Buffer * _Nonnull This);

void easyar_Drawable__dtor(easyar_Drawable * _Nonnull This);
void easyar_Drawable__retain(const easyar_Drawable * _Nonnull This, /* OUT */ easyar_Drawable * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Drawable__typeName(const easyar_Drawable * _Nonnull This);

void easyar_Frame__ctor(/* OUT */ easyar_Frame * _Nonnull * _Nonnull Return);
easyar_Vec2I easyar_Frame_size(const easyar_Frame * _Nonnull This);
double easyar_Frame_timestamp(const easyar_Frame * _Nonnull This);
int easyar_Frame_index(const easyar_Frame * _Nonnull This);
void easyar_Frame_images(const easyar_Frame * _Nonnull This, /* OUT */ easyar_ListOfPointerOfImage * _Nonnull * _Nonnull Return);
void easyar_Frame_targetInstances(const easyar_Frame * _Nonnull This, /* OUT */ easyar_ListOfPointerOfTargetInstance * _Nonnull * _Nonnull Return);
void easyar_Frame_text(easyar_Frame * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_Frame__dtor(easyar_Frame * _Nonnull This);
void easyar_Frame__retain(const easyar_Frame * _Nonnull This, /* OUT */ easyar_Frame * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Frame__typeName(const easyar_Frame * _Nonnull This);
void easyar_castFrameToDrawable(const easyar_Frame * _Nonnull This, /* OUT */ easyar_Drawable * _Nonnull * _Nonnull Return);
void easyar_tryCastDrawableToFrame(const easyar_Drawable * _Nonnull This, /* OUT */ easyar_Frame * _Nonnull * _Nonnull Return);

void easyar_Image_buffer(const easyar_Image * _Nonnull This, /* OUT */ easyar_Buffer * _Nonnull * _Nonnull Return);
int easyar_Image_format(const easyar_Image * _Nonnull This);
int easyar_Image_width(const easyar_Image * _Nonnull This);
int easyar_Image_height(const easyar_Image * _Nonnull This);
int easyar_Image_stride(const easyar_Image * _Nonnull This);
easyar_Opaque * _Nonnull easyar_Image_data(const easyar_Image * _Nonnull This);
void easyar_Image__dtor(easyar_Image * _Nonnull This);
void easyar_Image__retain(const easyar_Image * _Nonnull This, /* OUT */ easyar_Image * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Image__typeName(const easyar_Image * _Nonnull This);

void easyar_CameraCalibration__ctor(/* OUT */ easyar_CameraCalibration * _Nonnull * _Nonnull Return);
easyar_Vec2I easyar_CameraCalibration_size(const easyar_CameraCalibration * _Nonnull This);
easyar_Vec2F easyar_CameraCalibration_focalLength(const easyar_CameraCalibration * _Nonnull This);
easyar_Vec2F easyar_CameraCalibration_principalPoint(const easyar_CameraCalibration * _Nonnull This);
easyar_Vec4F easyar_CameraCalibration_distortionParameters(const easyar_CameraCalibration * _Nonnull This);
int easyar_CameraCalibration_rotation(const easyar_CameraCalibration * _Nonnull This);
easyar_Matrix44F easyar_CameraCalibration_projectionGL(easyar_CameraCalibration * _Nonnull This, float nearPlane, float farPlane);
void easyar_CameraCalibration__dtor(easyar_CameraCalibration * _Nonnull This);
void easyar_CameraCalibration__retain(const easyar_CameraCalibration * _Nonnull This, /* OUT */ easyar_CameraCalibration * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_CameraCalibration__typeName(const easyar_CameraCalibration * _Nonnull This);

void easyar_CameraDevice__ctor(/* OUT */ easyar_CameraDevice * _Nonnull * _Nonnull Return);
bool easyar_CameraDevice_start(easyar_CameraDevice * _Nonnull This);
bool easyar_CameraDevice_stop(easyar_CameraDevice * _Nonnull This);
void easyar_CameraDevice_requestPermissions(easyar_CameraDevice * _Nonnull This, easyar_FunctorOfVoidFromPermissionStatusAndString permissionCallback);
bool easyar_CameraDevice_open(easyar_CameraDevice * _Nonnull This, int camera);
bool easyar_CameraDevice_close(easyar_CameraDevice * _Nonnull This);
bool easyar_CameraDevice_isOpened(easyar_CameraDevice * _Nonnull This);
void easyar_CameraDevice_setHorizontalFlip(easyar_CameraDevice * _Nonnull This, bool flip);
float easyar_CameraDevice_frameRate(const easyar_CameraDevice * _Nonnull This);
int easyar_CameraDevice_supportedFrameRateCount(const easyar_CameraDevice * _Nonnull This);
float easyar_CameraDevice_supportedFrameRate(const easyar_CameraDevice * _Nonnull This, int idx);
bool easyar_CameraDevice_setFrameRate(easyar_CameraDevice * _Nonnull This, float fps);
easyar_Vec2I easyar_CameraDevice_size(const easyar_CameraDevice * _Nonnull This);
int easyar_CameraDevice_supportedSizeCount(const easyar_CameraDevice * _Nonnull This);
easyar_Vec2I easyar_CameraDevice_supportedSize(const easyar_CameraDevice * _Nonnull This, int idx);
bool easyar_CameraDevice_setSize(easyar_CameraDevice * _Nonnull This, easyar_Vec2I size);
float easyar_CameraDevice_zoomScale(const easyar_CameraDevice * _Nonnull This);
void easyar_CameraDevice_setZoomScale(easyar_CameraDevice * _Nonnull This, float scale);
float easyar_CameraDevice_minZoomScale(const easyar_CameraDevice * _Nonnull This);
float easyar_CameraDevice_maxZoomScale(const easyar_CameraDevice * _Nonnull This);
void easyar_CameraDevice_cameraCalibration(const easyar_CameraDevice * _Nonnull This, /* OUT */ easyar_CameraCalibration * _Nullable * _Nonnull Return);
bool easyar_CameraDevice_setFlashTorchMode(easyar_CameraDevice * _Nonnull This, bool on);
bool easyar_CameraDevice_setFocusMode(easyar_CameraDevice * _Nonnull This, int);
easyar_Matrix44F easyar_CameraDevice_projectionGL(easyar_CameraDevice * _Nonnull This, float nearPlane, float farPlane);
void easyar_CameraDevice__dtor(easyar_CameraDevice * _Nonnull This);
void easyar_CameraDevice__retain(const easyar_CameraDevice * _Nonnull This, /* OUT */ easyar_CameraDevice * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_CameraDevice__typeName(const easyar_CameraDevice * _Nonnull This);

void easyar_VideoPlayer__ctor(/* OUT */ easyar_VideoPlayer * _Nonnull * _Nonnull Return);
void easyar_VideoPlayer_setVideoType(easyar_VideoPlayer * _Nonnull This, int);
void easyar_VideoPlayer_setRenderTexture(easyar_VideoPlayer * _Nonnull This, easyar_Opaque * _Nonnull texture);
void easyar_VideoPlayer_open(easyar_VideoPlayer * _Nonnull This, easyar_String * _Nonnull path, int, easyar_FunctorOfVoidFromVideoStatus callback);
void easyar_VideoPlayer_close(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_play(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_stop(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_pause(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_isRenderTextureAvailable(easyar_VideoPlayer * _Nonnull This);
void easyar_VideoPlayer_updateFrame(easyar_VideoPlayer * _Nonnull This);
int easyar_VideoPlayer_duration(easyar_VideoPlayer * _Nonnull This);
int easyar_VideoPlayer_currentPosition(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_seek(easyar_VideoPlayer * _Nonnull This, int position);
easyar_Vec2I easyar_VideoPlayer_size(easyar_VideoPlayer * _Nonnull This);
float easyar_VideoPlayer_volume(easyar_VideoPlayer * _Nonnull This);
bool easyar_VideoPlayer_setVolume(easyar_VideoPlayer * _Nonnull This, float volume);
void easyar_VideoPlayer__dtor(easyar_VideoPlayer * _Nonnull This);
void easyar_VideoPlayer__retain(const easyar_VideoPlayer * _Nonnull This, /* OUT */ easyar_VideoPlayer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_VideoPlayer__typeName(const easyar_VideoPlayer * _Nonnull This);

void easyar_Renderer__ctor(/* OUT */ easyar_Renderer * _Nonnull * _Nonnull Return);
void easyar_Renderer_chooseAPI(easyar_Renderer * _Nonnull This, int);
void easyar_Renderer_setDevice(easyar_Renderer * _Nonnull This, easyar_Opaque * _Nonnull device);
bool easyar_Renderer_render(easyar_Renderer * _Nonnull This, easyar_Drawable * _Nullable frame, easyar_Vec4I viewport);
bool easyar_Renderer_renderToTexture(easyar_Renderer * _Nonnull This, easyar_Drawable * _Nullable frame, easyar_Opaque * _Nonnull texture);
bool easyar_Renderer_renderErrorMessage(easyar_Renderer * _Nonnull This, easyar_Vec4I viewport);
bool easyar_Renderer_renderErrorMessageToTexture(easyar_Renderer * _Nonnull This, easyar_Opaque * _Nonnull texture);
void easyar_Renderer__dtor(easyar_Renderer * _Nonnull This);
void easyar_Renderer__retain(const easyar_Renderer * _Nonnull This, /* OUT */ easyar_Renderer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Renderer__typeName(const easyar_Renderer * _Nonnull This);

bool easyar_Engine_initialize(easyar_String * _Nonnull key);
void easyar_Engine_onPause();
void easyar_Engine_onResume();
void easyar_Engine_setRotation(int rotation);
void easyar_Engine_versionString(/* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_Engine_name(/* OUT */ easyar_String * _Nonnull * _Nonnull Return);

bool easyar_FrameFilter_attachStreamer(easyar_FrameFilter * _Nonnull This, easyar_FrameStreamer * _Nullable obj);
bool easyar_FrameFilter_start(easyar_FrameFilter * _Nonnull This);
bool easyar_FrameFilter_stop(easyar_FrameFilter * _Nonnull This);
void easyar_FrameFilter__dtor(easyar_FrameFilter * _Nonnull This);
void easyar_FrameFilter__retain(const easyar_FrameFilter * _Nonnull This, /* OUT */ easyar_FrameFilter * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_FrameFilter__typeName(const easyar_FrameFilter * _Nonnull This);

void easyar_FrameStreamer_peek(easyar_FrameStreamer * _Nonnull This, /* OUT */ easyar_Frame * _Nonnull * _Nonnull Return);
bool easyar_FrameStreamer_start(easyar_FrameStreamer * _Nonnull This);
bool easyar_FrameStreamer_stop(easyar_FrameStreamer * _Nonnull This);
void easyar_FrameStreamer__dtor(easyar_FrameStreamer * _Nonnull This);
void easyar_FrameStreamer__retain(const easyar_FrameStreamer * _Nonnull This, /* OUT */ easyar_FrameStreamer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_FrameStreamer__typeName(const easyar_FrameStreamer * _Nonnull This);

void easyar_CameraFrameStreamer__ctor(/* OUT */ easyar_CameraFrameStreamer * _Nonnull * _Nonnull Return);
bool easyar_CameraFrameStreamer_attachCamera(easyar_CameraFrameStreamer * _Nonnull This, easyar_CameraDevice * _Nullable obj);
void easyar_CameraFrameStreamer_peek(easyar_CameraFrameStreamer * _Nonnull This, /* OUT */ easyar_Frame * _Nonnull * _Nonnull Return);
bool easyar_CameraFrameStreamer_start(easyar_CameraFrameStreamer * _Nonnull This);
bool easyar_CameraFrameStreamer_stop(easyar_CameraFrameStreamer * _Nonnull This);
void easyar_CameraFrameStreamer__dtor(easyar_CameraFrameStreamer * _Nonnull This);
void easyar_CameraFrameStreamer__retain(const easyar_CameraFrameStreamer * _Nonnull This, /* OUT */ easyar_CameraFrameStreamer * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_CameraFrameStreamer__typeName(const easyar_CameraFrameStreamer * _Nonnull This);
void easyar_castCameraFrameStreamerToFrameStreamer(const easyar_CameraFrameStreamer * _Nonnull This, /* OUT */ easyar_FrameStreamer * _Nonnull * _Nonnull Return);
void easyar_tryCastFrameStreamerToCameraFrameStreamer(const easyar_FrameStreamer * _Nonnull This, /* OUT */ easyar_CameraFrameStreamer * _Nonnull * _Nonnull Return);

void easyar_QRCodeScanner__ctor(/* OUT */ easyar_QRCodeScanner * _Nonnull * _Nonnull Return);
bool easyar_QRCodeScanner_attachStreamer(easyar_QRCodeScanner * _Nonnull This, easyar_FrameStreamer * _Nullable obj);
bool easyar_QRCodeScanner_start(easyar_QRCodeScanner * _Nonnull This);
bool easyar_QRCodeScanner_stop(easyar_QRCodeScanner * _Nonnull This);
void easyar_QRCodeScanner__dtor(easyar_QRCodeScanner * _Nonnull This);
void easyar_QRCodeScanner__retain(const easyar_QRCodeScanner * _Nonnull This, /* OUT */ easyar_QRCodeScanner * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_QRCodeScanner__typeName(const easyar_QRCodeScanner * _Nonnull This);
void easyar_castQRCodeScannerToFrameFilter(const easyar_QRCodeScanner * _Nonnull This, /* OUT */ easyar_FrameFilter * _Nonnull * _Nonnull Return);
void easyar_tryCastFrameFilterToQRCodeScanner(const easyar_FrameFilter * _Nonnull This, /* OUT */ easyar_QRCodeScanner * _Nonnull * _Nonnull Return);

int easyar_Target_runtimeID(const easyar_Target * _Nonnull This);
void easyar_Target_uid(const easyar_Target * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_Target_name(const easyar_Target * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_Target_meta(const easyar_Target * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_Target_setMeta(easyar_Target * _Nonnull This, easyar_String * _Nonnull data);
void easyar_Target__dtor(easyar_Target * _Nonnull This);
void easyar_Target__retain(const easyar_Target * _Nonnull This, /* OUT */ easyar_Target * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_Target__typeName(const easyar_Target * _Nonnull This);

void easyar_TargetInstance__ctor(/* OUT */ easyar_TargetInstance * _Nonnull * _Nonnull Return);
int easyar_TargetInstance_status(const easyar_TargetInstance * _Nonnull This);
void easyar_TargetInstance_target(const easyar_TargetInstance * _Nonnull This, /* OUT */ easyar_Target * _Nullable * _Nonnull Return);
easyar_Matrix34F easyar_TargetInstance_pose(const easyar_TargetInstance * _Nonnull This);
easyar_Matrix44F easyar_TargetInstance_poseGL(const easyar_TargetInstance * _Nonnull This);
void easyar_TargetInstance__dtor(easyar_TargetInstance * _Nonnull This);
void easyar_TargetInstance__retain(const easyar_TargetInstance * _Nonnull This, /* OUT */ easyar_TargetInstance * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_TargetInstance__typeName(const easyar_TargetInstance * _Nonnull This);

void easyar_TargetTracker_loadTarget(easyar_TargetTracker * _Nonnull This, easyar_Target * _Nonnull target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_TargetTracker_unloadTarget(easyar_TargetTracker * _Nonnull This, easyar_Target * _Nonnull target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_TargetTracker_loadTargetBlocked(easyar_TargetTracker * _Nonnull This, easyar_Target * _Nonnull target);
bool easyar_TargetTracker_unloadTargetBlocked(easyar_TargetTracker * _Nonnull This, easyar_Target * _Nonnull target);
void easyar_TargetTracker_targets(easyar_TargetTracker * _Nonnull This, /* OUT */ easyar_ListOfPointerOfTarget * _Nonnull * _Nonnull Return);
bool easyar_TargetTracker_setSimultaneousNum(easyar_TargetTracker * _Nonnull This, int num);
int easyar_TargetTracker_simultaneousNum(easyar_TargetTracker * _Nonnull This);
bool easyar_TargetTracker_attachStreamer(easyar_TargetTracker * _Nonnull This, easyar_FrameStreamer * _Nullable obj);
bool easyar_TargetTracker_start(easyar_TargetTracker * _Nonnull This);
bool easyar_TargetTracker_stop(easyar_TargetTracker * _Nonnull This);
void easyar_TargetTracker__dtor(easyar_TargetTracker * _Nonnull This);
void easyar_TargetTracker__retain(const easyar_TargetTracker * _Nonnull This, /* OUT */ easyar_TargetTracker * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_TargetTracker__typeName(const easyar_TargetTracker * _Nonnull This);
void easyar_castTargetTrackerToFrameFilter(const easyar_TargetTracker * _Nonnull This, /* OUT */ easyar_FrameFilter * _Nonnull * _Nonnull Return);
void easyar_tryCastFrameFilterToTargetTracker(const easyar_FrameFilter * _Nonnull This, /* OUT */ easyar_TargetTracker * _Nonnull * _Nonnull Return);

void easyar_ImageTarget__ctor(/* OUT */ easyar_ImageTarget * _Nonnull * _Nonnull Return);
bool easyar_ImageTarget_setup(easyar_ImageTarget * _Nonnull This, easyar_String * _Nonnull path, int storageType, easyar_String * _Nonnull name);
void easyar_ImageTarget_setupAll(easyar_String * _Nonnull path, int storageType, /* OUT */ easyar_ListOfPointerOfImageTarget * _Nonnull * _Nonnull Return);
easyar_Vec2F easyar_ImageTarget_size(const easyar_ImageTarget * _Nonnull This);
bool easyar_ImageTarget_setSize(easyar_ImageTarget * _Nonnull This, easyar_Vec2F size);
void easyar_ImageTarget_images(easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_ListOfPointerOfImage * _Nonnull * _Nonnull Return);
int easyar_ImageTarget_runtimeID(const easyar_ImageTarget * _Nonnull This);
void easyar_ImageTarget_uid(const easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_ImageTarget_name(const easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_ImageTarget_meta(const easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_String * _Nonnull * _Nonnull Return);
void easyar_ImageTarget_setMeta(easyar_ImageTarget * _Nonnull This, easyar_String * _Nonnull data);
void easyar_ImageTarget__dtor(easyar_ImageTarget * _Nonnull This);
void easyar_ImageTarget__retain(const easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_ImageTarget * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_ImageTarget__typeName(const easyar_ImageTarget * _Nonnull This);
void easyar_castImageTargetToTarget(const easyar_ImageTarget * _Nonnull This, /* OUT */ easyar_Target * _Nonnull * _Nonnull Return);
void easyar_tryCastTargetToImageTarget(const easyar_Target * _Nonnull This, /* OUT */ easyar_ImageTarget * _Nonnull * _Nonnull Return);

void easyar_ImageTracker__ctor(/* OUT */ easyar_ImageTracker * _Nonnull * _Nonnull Return);
void easyar_ImageTracker_createWithMode(int, /* OUT */ easyar_ImageTracker * _Nonnull * _Nonnull Return);
void easyar_ImageTracker_loadTarget(easyar_ImageTracker * _Nonnull This, easyar_Target * _Nonnull target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_ImageTracker_unloadTarget(easyar_ImageTracker * _Nonnull This, easyar_Target * _Nonnull target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_ImageTracker_loadTargetBlocked(easyar_ImageTracker * _Nonnull This, easyar_Target * _Nonnull target);
bool easyar_ImageTracker_unloadTargetBlocked(easyar_ImageTracker * _Nonnull This, easyar_Target * _Nonnull target);
void easyar_ImageTracker_targets(easyar_ImageTracker * _Nonnull This, /* OUT */ easyar_ListOfPointerOfTarget * _Nonnull * _Nonnull Return);
bool easyar_ImageTracker_setSimultaneousNum(easyar_ImageTracker * _Nonnull This, int num);
int easyar_ImageTracker_simultaneousNum(easyar_ImageTracker * _Nonnull This);
bool easyar_ImageTracker_attachStreamer(easyar_ImageTracker * _Nonnull This, easyar_FrameStreamer * _Nullable obj);
bool easyar_ImageTracker_start(easyar_ImageTracker * _Nonnull This);
bool easyar_ImageTracker_stop(easyar_ImageTracker * _Nonnull This);
void easyar_ImageTracker__dtor(easyar_ImageTracker * _Nonnull This);
void easyar_ImageTracker__retain(const easyar_ImageTracker * _Nonnull This, /* OUT */ easyar_ImageTracker * _Nonnull * _Nonnull Return);
const char * _Nonnull easyar_ImageTracker__typeName(const easyar_ImageTracker * _Nonnull This);
void easyar_castImageTrackerToFrameFilter(const easyar_ImageTracker * _Nonnull This, /* OUT */ easyar_FrameFilter * _Nonnull * _Nonnull Return);
void easyar_tryCastFrameFilterToImageTracker(const easyar_FrameFilter * _Nonnull This, /* OUT */ easyar_ImageTracker * _Nonnull * _Nonnull Return);
void easyar_castImageTrackerToTargetTracker(const easyar_ImageTracker * _Nonnull This, /* OUT */ easyar_TargetTracker * _Nonnull * _Nonnull Return);
void easyar_tryCastTargetTrackerToImageTracker(const easyar_TargetTracker * _Nonnull This, /* OUT */ easyar_ImageTracker * _Nonnull * _Nonnull Return);

void easyar_ListOfPointerOfTarget__ctor(easyar_Target * _Nonnull const * _Nullable begin, easyar_Target * _Nonnull const * _Nullable end, /* OUT */ easyar_ListOfPointerOfTarget * _Nonnull * _Nonnull Return);
void easyar_ListOfPointerOfTarget__dtor(easyar_ListOfPointerOfTarget * _Nonnull This);
void easyar_ListOfPointerOfTarget_copy(const easyar_ListOfPointerOfTarget * _Nonnull This, /* OUT */ easyar_ListOfPointerOfTarget * _Nonnull * _Nonnull Return);
int easyar_ListOfPointerOfTarget_size(const easyar_ListOfPointerOfTarget * _Nonnull This);
easyar_Target * _Nonnull easyar_ListOfPointerOfTarget_at(const easyar_ListOfPointerOfTarget * _Nonnull This, int index);

void easyar_ListOfPointerOfImage__ctor(easyar_Image * _Nonnull const * _Nullable begin, easyar_Image * _Nonnull const * _Nullable end, /* OUT */ easyar_ListOfPointerOfImage * _Nonnull * _Nonnull Return);
void easyar_ListOfPointerOfImage__dtor(easyar_ListOfPointerOfImage * _Nonnull This);
void easyar_ListOfPointerOfImage_copy(const easyar_ListOfPointerOfImage * _Nonnull This, /* OUT */ easyar_ListOfPointerOfImage * _Nonnull * _Nonnull Return);
int easyar_ListOfPointerOfImage_size(const easyar_ListOfPointerOfImage * _Nonnull This);
easyar_Image * _Nonnull easyar_ListOfPointerOfImage_at(const easyar_ListOfPointerOfImage * _Nonnull This, int index);

void easyar_ListOfPointerOfTargetInstance__ctor(easyar_TargetInstance * _Nonnull const * _Nullable begin, easyar_TargetInstance * _Nonnull const * _Nullable end, /* OUT */ easyar_ListOfPointerOfTargetInstance * _Nonnull * _Nonnull Return);
void easyar_ListOfPointerOfTargetInstance__dtor(easyar_ListOfPointerOfTargetInstance * _Nonnull This);
void easyar_ListOfPointerOfTargetInstance_copy(const easyar_ListOfPointerOfTargetInstance * _Nonnull This, /* OUT */ easyar_ListOfPointerOfTargetInstance * _Nonnull * _Nonnull Return);
int easyar_ListOfPointerOfTargetInstance_size(const easyar_ListOfPointerOfTargetInstance * _Nonnull This);
easyar_TargetInstance * _Nonnull easyar_ListOfPointerOfTargetInstance_at(const easyar_ListOfPointerOfTargetInstance * _Nonnull This, int index);

void easyar_ListOfPointerOfImageTarget__ctor(easyar_ImageTarget * _Nonnull const * _Nullable begin, easyar_ImageTarget * _Nonnull const * _Nullable end, /* OUT */ easyar_ListOfPointerOfImageTarget * _Nonnull * _Nonnull Return);
void easyar_ListOfPointerOfImageTarget__dtor(easyar_ListOfPointerOfImageTarget * _Nonnull This);
void easyar_ListOfPointerOfImageTarget_copy(const easyar_ListOfPointerOfImageTarget * _Nonnull This, /* OUT */ easyar_ListOfPointerOfImageTarget * _Nonnull * _Nonnull Return);
int easyar_ListOfPointerOfImageTarget_size(const easyar_ListOfPointerOfImageTarget * _Nonnull This);
easyar_ImageTarget * _Nonnull easyar_ListOfPointerOfImageTarget_at(const easyar_ListOfPointerOfImageTarget * _Nonnull This, int index);

#ifdef __cplusplus
}
#endif
