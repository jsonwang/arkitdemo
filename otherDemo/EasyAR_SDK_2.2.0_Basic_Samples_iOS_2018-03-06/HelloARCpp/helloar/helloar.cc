//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#include "helloar.hpp"

#include "boxrenderer.hpp"

#include <easyar/vector.hpp>
#include <easyar/camera.hpp>
#include <easyar/framestreamer.hpp>
#include <easyar/imagetracker.hpp>
#include <easyar/imagetarget.hpp>
#include <easyar/renderer.hpp>

#include <cmath>
#include <string>
#include <algorithm>
#include <memory>

#if defined __APPLE__
#   include <OpenGLES/ES2/gl.h>
#   include <cstdio>
#   define LOGI(...) std::printf(__VA_ARGS__)
#else
#   include <GLES2/gl2.h>
#   include <android/log.h>
#   define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "EasyAR", __VA_ARGS__)
#endif

std::shared_ptr<easyar::CameraDevice> camera;
std::shared_ptr<easyar::CameraFrameStreamer> streamer;
std::vector<std::shared_ptr<easyar::ImageTracker>> trackers;
std::shared_ptr<easyar::Renderer> videobg_renderer;
std::shared_ptr<BoxRenderer> box_renderer;
bool viewport_changed{false};
easyar::Vec2I view_size{{{0, 0}}};
int rotation{0};
easyar::Vec4I viewport{{0, 0, 1280, 720}};

void loadFromImage(std::shared_ptr<easyar::ImageTracker> tracker, const std::string& path)
{
    auto target = std::make_shared<easyar::ImageTarget>();
    std::string jstr = "{\n"
        "  \"images\" :\n"
        "  [\n"
        "    {\n"
        "      \"image\" : \"" + path + "\",\n"
        "      \"name\" : \"" + path.substr(0, path.find_first_of(".")) + "\"\n"
        "    }\n"
        "  ]\n"
        "}";
    target->setup(jstr.c_str(), static_cast<int>(easyar::StorageType::Assets) | static_cast<int>(easyar::StorageType::Json), "");
    tracker->loadTarget(target, [](std::shared_ptr<easyar::Target> target, bool status) {
        LOGI("load target (%d): %s (%d)", status, target->name().c_str(), target->runtimeID());
    });
}

void loadFromJsonFile(std::shared_ptr<easyar::ImageTracker> tracker, const std::string& path, const std::string& targetname)
{
    auto target = std::make_shared<easyar::ImageTarget>();
    target->setup(path, static_cast<int>(easyar::StorageType::Assets), targetname);
    tracker->loadTarget(target, [](std::shared_ptr<easyar::Target> target, bool status) {
        LOGI("load target (%d): %s (%d)", status, target->name().c_str(), target->runtimeID());
    });
}

void loadAllFromJsonFile(std::shared_ptr<easyar::ImageTracker> tracker, const std::string& path)
{
    for (auto && target : easyar::ImageTarget::setupAll(path, static_cast<int>(easyar::StorageType::Assets))) {
        tracker->loadTarget(target, [](std::shared_ptr<easyar::Target> target, bool status) {
            LOGI("load target (%d): %s (%d)", status, target->name().c_str(), target->runtimeID());
        });
    }
}

bool initialize()
{
    camera = std::make_shared<easyar::CameraDevice>();
    streamer = std::make_shared<easyar::CameraFrameStreamer>();
    streamer->attachCamera(camera);
    videobg_renderer = std::make_shared<easyar::Renderer>();
    box_renderer = std::make_shared<BoxRenderer>();

    bool status = true;
    status &= camera->open(static_cast<int>(easyar::CameraDeviceType::Default));
    camera->setSize(easyar::Vec2I{{1280, 720}});

    if (!status) { return status; }
    auto tracker = std::make_shared<easyar::ImageTracker>();
    tracker->attachStreamer(streamer);
    loadFromJsonFile(tracker, "targets.json", "argame");
    loadFromJsonFile(tracker, "targets.json", "idback");
    loadAllFromJsonFile(tracker, "targets2.json");
    loadFromImage(tracker, "namecard.jpg");
    trackers.push_back(tracker);

    return status;
}

void finalize()
{
    trackers.clear();
    box_renderer = nullptr;
    videobg_renderer = nullptr;
    streamer = nullptr;
    camera = nullptr;
}

bool start()
{
    bool status = true;
    status &= camera->start();
    status &= streamer->start();
    camera->setFocusMode(easyar::CameraDeviceFocusMode::Continousauto);
    for (auto && tracker : trackers) {
        status &= tracker->start();
    }
    return status;
}

bool stop()
{
    bool status = true;
    for (auto && tracker : trackers) {
        status &= tracker->stop();
    }
    status &= streamer->stop();
    status &= camera->stop();
    return status;
}

void initGL()
{
    box_renderer->init();
}

void resizeGL(int width, int height)
{
    view_size = easyar::Vec2I{{width, height}};
    viewport_changed = true;
}

void updateViewport()
{
    auto calib = camera != nullptr ? camera->cameraCalibration() : nullptr;
    int rotation = calib != nullptr ? calib->rotation() : 0;
    if (rotation != ::rotation) {
        ::rotation = rotation;
        viewport_changed = true;
    }
    if (viewport_changed) {
        auto size = easyar::Vec2I{{{1, 1}}};
        if (camera && camera->isOpened()) {
            size = camera->size();
        }
        if (rotation == 90 || rotation == 270) {
            std::swap(size.data[0], size.data[1]);
        }
        float scaleRatio = std::max((float)view_size.data[0] / (float)size.data[0], (float)view_size.data[1] / (float)size.data[1]);
        auto viewport_size = easyar::Vec2I{{{(int)std::round(size.data[0] * scaleRatio), (int)std::round(size.data[1] * scaleRatio)}}};
        viewport = easyar::Vec4I{{{(view_size.data[0] - viewport_size.data[0]) / 2, (view_size.data[1] - viewport_size.data[1]) / 2, viewport_size.data[0], viewport_size.data[1]}}};

        if (camera && camera->isOpened()) {
            viewport_changed = false;
        }
    }
}

void render()
{
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (videobg_renderer != nullptr) {
        auto default_viewport = easyar::Vec4I{{{0, 0, view_size.data[0], view_size.data[1]}}};
        glViewport(default_viewport.data[0], default_viewport.data[1], default_viewport.data[2], default_viewport.data[3]);
        if (videobg_renderer->renderErrorMessage(default_viewport)) {
            return;
        }
    }

    auto frame = streamer->peek();
    updateViewport();
    glViewport(viewport.data[0], viewport.data[1], viewport.data[2], viewport.data[3]);

    videobg_renderer->render(frame, viewport);

    for (auto && target : frame->targetInstances()) {
        auto status = target->status();
        if (status == easyar::TargetStatus::Tracked) {
            auto imagetarget = std::dynamic_pointer_cast<easyar::ImageTarget>(target->target());
            if (!imagetarget)
                continue;
            box_renderer->render(camera->projectionGL(0.2f, 500.f), target->poseGL(), imagetarget->size());
        }
    }
}
