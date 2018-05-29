//=============================================================================================================================
//
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import OpenGLES
import EasyARSwift

internal class BoxRenderer {
    private var program_box: GLuint
    private var pos_coord_box: Int32
    private var pos_color_box: Int32
    private var pos_trans_box: Int32
    private var pos_proj_box: Int32
    private var vbo_coord_box: GLuint
    private var vbo_color_box: GLuint
    private var vbo_color_box_2: GLuint
    private var vbo_faces_box: GLuint
    
    public init() {
        let box_vert = "uniform mat4 trans;\n"
            + "uniform mat4 proj;\n"
            + "attribute vec4 coord;\n"
            + "attribute vec4 color;\n"
            + "varying vec4 vcolor;\n"
            + "\n"
            + "void main(void)\n"
            + "{\n"
            + "    vcolor = color;\n"
            + "    gl_Position = proj*trans*coord;\n"
            + "}\n"
            + "\n"
        
        let box_frag = "#ifdef GL_ES\n"
            + "precision highp float;\n"
            + "#endif\n"
            + "varying vec4 vcolor;\n"
            + "\n"
            + "void main(void)\n"
            + "{\n"
            + "    gl_FragColor = vcolor;\n"
            + "}\n"
            + "\n"
        
        program_box = glCreateProgram()
        let vertShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
        box_vert.utf8CString.withUnsafeBufferPointer { p in
            var s = p.baseAddress
            glShaderSource(vertShader, 1, &s, nil)
        }
        glCompileShader(vertShader)
        let fragShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        box_frag.utf8CString.withUnsafeBufferPointer { p in
            var s = p.baseAddress
            glShaderSource(fragShader, 1, &s, nil)
        }
        glCompileShader(fragShader)
        glAttachShader(program_box, vertShader)
        glAttachShader(program_box, fragShader)
        glLinkProgram(program_box)
        glUseProgram(program_box)
        pos_coord_box = glGetAttribLocation(program_box, "coord")
        pos_color_box = glGetAttribLocation(program_box, "color")
        pos_trans_box = glGetUniformLocation(program_box, "trans")
        pos_proj_box = glGetUniformLocation(program_box, "proj")
        
        vbo_coord_box = 0
        glGenBuffers(1, &vbo_coord_box)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_coord_box)
        let cube_vertices: [GLfloat] = [
            /* +z */ 1.0 / 2, 1.0 / 2, 0.01 / 2, 1.0 / 2, -1.0 / 2, 0.01 / 2, -1.0 / 2, -1.0 / 2, 0.01 / 2, -1.0 / 2, 1.0 / 2, 0.01 / 2,
            /* -z */ 1.0 / 2, 1.0 / 2, -0.01 / 2, 1.0 / 2, -1.0 / 2, -0.01 / 2, -1.0 / 2, -1.0 / 2, -0.01 / 2, -1.0 / 2, 1.0 / 2, -0.01 / 2] // 8 x 3
        cube_vertices.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_DYNAMIC_DRAW))
        }
        
        vbo_color_box = 0
        glGenBuffers(1, &vbo_color_box)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_color_box)
        let cube_vertex_colors: [GLubyte] = [
            255, 0, 0, 128, 0, 255, 0, 128, 0, 0, 255, 128, 0, 0, 0, 128,
            0, 255, 255, 128, 255, 0, 255, 128, 255, 255, 0, 128, 255, 255, 255, 128] // 8 x 4
        cube_vertex_colors.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_STATIC_DRAW))
        }
        
        vbo_color_box_2 = 0
        glGenBuffers(1, &vbo_color_box_2)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_color_box_2)
        let cube_vertex_colors_2: [GLubyte] = [
            255, 0, 0, 255, 255, 255, 0, 255, 0, 255, 0, 255, 255, 0, 255, 255,
            255, 0, 255, 255, 255, 255, 255, 255, 0, 255, 255, 255, 255, 0, 255, 255] // 8 x 4
        cube_vertex_colors_2.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_STATIC_DRAW))
        }

        vbo_faces_box = 0
        glGenBuffers(1, &vbo_faces_box)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo_faces_box)
        let cube_faces: [GLushort] = [
            /* +z */ 3, 2, 1, 0, /* -y */ 2, 3, 7, 6, /* +y */ 0, 1, 5, 4,
            /* -x */ 3, 0, 4, 7, /* +x */ 1, 2, 6, 5, /* -z */ 4, 5, 6, 7] // 6 x 4
        cube_faces.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_STATIC_DRAW))
        }
    }
    
    public func render(_ projectionMatrix: Matrix44F, _ cameraview: Matrix44F, _ size: Vec2F) {
        let (size0, size1) = size.data
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_coord_box)
        let height = size0 / 1000
        let cube_vertices: [GLfloat] = [
            /* +z */ size0 / 2, size1 / 2, height / 2, size0 / 2, -size1 / 2, height / 2, -size0 / 2, -size1 / 2, height / 2, -size0 / 2, size1 / 2, height / 2,
            /* -z */size0 / 2, size1 / 2, 0, size0 / 2, -size1 / 2, 0, -size0 / 2, -size1 / 2, 0, -size0 / 2, size1 / 2, 0] // 8 x 3
        cube_vertices.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_DYNAMIC_DRAW))
        }
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glEnable(GLenum(GL_DEPTH_TEST))
        glUseProgram(program_box)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_coord_box)
        glEnableVertexAttribArray(GLuint(pos_coord_box))
        glVertexAttribPointer(GLuint(pos_coord_box), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_color_box)
        glEnableVertexAttribArray(GLuint(pos_color_box))
        glVertexAttribPointer(GLuint(pos_color_box), 4, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, nil)
        
        var cameraview_data = cameraview.data
        var projectionMatrix_data = projectionMatrix.data
        withUnsafePointer(to: &cameraview_data) { p in
            glUniformMatrix4fv(pos_trans_box, 1, GLboolean(GL_FALSE), UnsafePointer<GLfloat>(OpaquePointer(p)))
        }
        withUnsafePointer(to: &projectionMatrix_data) { p in
            glUniformMatrix4fv(pos_proj_box, 1, GLboolean(GL_FALSE), UnsafePointer<GLfloat>(OpaquePointer(p)))
        }
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo_faces_box)
        for i in 0..<6 {
            glDrawElements(GLenum(GL_TRIANGLE_FAN), 4, GLenum(GL_UNSIGNED_SHORT), UnsafeRawPointer(bitPattern: i * 4 * MemoryLayout<GLushort>.size))
        }
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_coord_box)
        let cube_vertices_2: [GLfloat] = [
            /* +z */ size0 / 4, size1 / 4, size0 / 4, size0 / 4, -size1 / 4, size0 / 4, -size0 / 4, -size1 / 4, size0 / 4, -size0 / 4, size1 / 4, size0 / 4,
            /* -z */ size0 / 4, size1 / 4, 0, size0 / 4, -size1 / 4, 0, -size0 / 4, -size1 / 4, 0, -size0 / 4, size1 / 4, 0] // 8 x 3
        cube_vertices_2.withUnsafeBytes { p in
            glBufferData(GLenum(GL_ARRAY_BUFFER), p.count, p.baseAddress, GLenum(GL_DYNAMIC_DRAW))
        }
        glEnableVertexAttribArray(GLuint(pos_coord_box))
        glVertexAttribPointer(GLuint(pos_coord_box), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo_color_box_2)
        glEnableVertexAttribArray(GLuint(pos_color_box))
        glVertexAttribPointer(GLuint(pos_color_box), 4, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), 0, nil)
        for i in 0..<6 {
            glDrawElements(GLenum(GL_TRIANGLE_FAN), 4, GLenum(GL_UNSIGNED_SHORT), UnsafeRawPointer(bitPattern: i * 4 * MemoryLayout<GLushort>.size))
        }
    }
}
