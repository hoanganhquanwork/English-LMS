<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật bài học dạng video</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .lesson-content-page {
                display: flex;
                gap: 24px;
                min-height: 100vh;
            }

            .topic-sidebar {
                width: 320px;
                background: #fff;
                border-radius: 12px;
                padding: 16px;
                box-shadow: 0 2px 8px rgba(0,0,0,.08);
                height: fit-content;
            }

            .sidebar-header {
                font-weight: 600;
                margin-bottom: 12px;
                color: #2c3e50;
                font-size: 14px;
            }

            .sidebar-search {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 10px;
            }

            .sidebar-search input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
            }

            .topic-tree {
                border: 1px solid #eee;
                border-radius: 8px;
                height: 400px;
                overflow-y: auto;
                padding: 8px;
            }

            .tree-item {
                padding: 8px 12px;
                margin: 2px 0;
                border-radius: 6px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                transition: all 0.2s;
            }

            .tree-item:hover {
                background: #f5f7fb;
            }

            .tree-item.active {
                background: #3498db;
                color: white;
            }

            .tree-item i {
                width: 16px;
                text-align: center;
            }

            .guide-section {
                margin-top: 20px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }

            .guide-label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                font-size: 12px;
            }

            .guide-icon {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12px;
                color: #7f8c8d;
            }

            .main-content {
                flex: 1;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,.08);
                padding: 24px;
            }

            .back-link{
                display:inline-flex;
                align-items:center;
                gap:8px;
                color:#2c3e50;
                text-decoration:none;
                margin-bottom:12px
            }
            .page-title-wrap{
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:16px
            }

            .module-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 8px 12px;
                margin: 2px 0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s;
            }

            .module-header:hover {
                background: #f5f7fb;
            }

            .module-title {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .module-actions {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .add-lesson-btn {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #3498db;
                color: white;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                transition: all 0.2s;
            }

            .add-lesson-btn:hover {
                background: #2980b9;
                transform: scale(1.1);
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 6px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                min-width: 180px;
                display: none;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                padding: 8px 12px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 13px;
                color: #2c3e50;
                transition: background 0.2s;
            }

            .dropdown-item:hover {
                background: #f5f7fb;
            }

            .dropdown-item i {
                width: 16px;
                text-align: center;
            }

            .lesson-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 1px solid #eee;
            }

            .lesson-title {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .back-arrow {
                color: #2c3e50;
                text-decoration: none;
                font-size: 18px;
            }

            .lesson-title h1 {
                margin: 0;
                font-size: 24px;
                color: #2c3e50;
            }

            .lesson-actions {
                display: flex;
                gap: 12px;
            }

            .action-btn {
                padding: 8px 16px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background: white;
                color: #2c3e50;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: all 0.2s;
            }

            .action-btn:hover {
                background: #f5f7fb;
                border-color: #3498db;
            }

            .delete-lesson-btn {
                background: #e74c3c;
                color: white;
                border-color: #e74c3c;
            }

            .delete-lesson-btn:hover {
                background: #c0392b;
                border-color: #c0392b;
                color: white;
            }

            .lesson-form {
                margin-bottom: 24px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                align-items: stretch;
                width: 100%;
            }

            .form-group input {
                width: 100%;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 500;
                margin: 0;
                box-sizing: border-box;
            }

            .video-container {
                width: 100%;
                display: flex;
                justify-content: center;
                margin-bottom: 30px;
            }

            .video-wrapper {
                position: relative;
                width: 100%;
                max-width: 800px;
                height: 0;
                padding-bottom: 40%; /* Giảm chiều cao từ 56.25% xuống 40% */
                background: #000;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            }

            .video-iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
                border-radius: 12px;
            }

            .delete-video-btn {
                position: absolute;
                top: 12px;
                right: 6px;
                width: 36px;
                height: 36px;
                background: rgba(231, 76, 60, 0.9);
                border: none;
                border-radius: 50%;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                transition: all 0.3s;
                z-index: 10;
                box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            }

            .delete-video-btn:hover {
                background: rgba(231, 76, 60, 1);
                transform: scale(1.1);
                box-shadow: 0 4px 12px rgba(231, 76, 60, 0.4);
            }

            .video-player {
                background: #000;
                border-radius: 8px;
            }

            .video-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 16px;
                background: rgba(0,0,0,0.8);
                color: white;
            }

            .video-info {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .video-avatar {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                object-fit: cover;
            }

            .video-channel {
                font-size: 14px;
                font-weight: 500;
            }

            .video-actions-header {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .share-btn {
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.3);
                color: white;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 12px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 4px;
                transition: all 0.2s;
            }

            .share-btn:hover {
                background: rgba(255,255,255,0.2);
            }

            .delete-video {
                width: 28px;
                height: 28px;
                background: rgba(231, 76, 60, 0.8);
                border: none;
                border-radius: 50%;
                color: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                transition: all 0.2s;
            }

            .delete-video:hover {
                background: rgba(231, 76, 60, 1);
            }

            .video-content {
                position: relative;
                width: 100%;
                height: 400px;
            }

            .video-thumbnail {
                width: 100%;
                height: 100%;
                position: relative;
            }

            .video-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .video-overlay {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.3);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .play-button {
                width: 80px;
                height: 80px;
                background: rgba(255,255,255,0.9);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                color: #2c3e50;
                cursor: pointer;
                transition: all 0.3s;
            }

            .play-button:hover {
                background: white;
                transform: scale(1.1);
            }

            .video-controls {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                background: rgba(0,0,0,0.8);
                color: white;
                gap: 12px;
            }

            .controls-left {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .control-btn {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 4px;
                border-radius: 4px;
                transition: all 0.2s;
            }

            .control-btn:hover {
                background: rgba(255,255,255,0.1);
            }

            .progress-container {
                flex: 1;
                margin: 0 12px;
            }

            .progress-bar {
                width: 100%;
                height: 4px;
                background: rgba(255,255,255,0.3);
                border-radius: 2px;
                position: relative;
                cursor: pointer;
            }

            .progress-fill {
                width: 30%;
                height: 100%;
                background: #ff0000;
                border-radius: 2px;
                transition: width 0.2s;
            }

            .controls-right {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .time-display {
                font-size: 12px;
                font-family: monospace;
            }

            .youtube-logo {
                color: #ff0000;
                font-size: 16px;
            }

            .video-actions {
                display: flex;
                gap: 12px;
                margin-bottom: 24px;
            }

            .video-action-btn {
                padding: 10px 16px;
                border: 1px solid #3498db;
                border-radius: 6px;
                background: #3498db;
                color: white;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s;
            }

            .video-action-btn:hover {
                background: #2980b9;
                border-color: #2980b9;
            }

            .video-action-btn.secondary {
                background: white;
                color: #2c3e50;
                border-color: #ddd;
            }

            .video-action-btn.secondary:hover {
                background: #f5f7fb;
                border-color: #3498db;
            }

            .action-buttons {
                display: flex;
                gap: 12px;
                margin: 20px 0;
                flex-wrap: wrap;
            }

            .btn-action {
                padding: 10px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: white;
                color: #6c757d;
            }

            .btn-action:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .btn-action.btn-primary {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }

            .btn-action.btn-primary:hover {
                background: #0056b3;
                border-color: #0056b3;
                box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            }

            .btn-action.btn-secondary {
                background: white;
                color: #6c757d;
                border-color: #ddd;
            }

            .btn-action.btn-secondary:hover {
                background: #f8f9fa;
                border-color: #adb5bd;
                color: #495057;
            }

            .page-actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-secondary {
                background: #95a5a6;
                color: white;
                border: 1px solid #95a5a6;
            }

            .btn-secondary:hover {
                background: #7f8c8d;
            }

            .btn-primary {
                background: #3498db;
                color: white;
                border: 1px solid #3498db;
            }

            .btn-primary:hover {
                background: #2980b9;
            }

            /* Questions Section Styling - Matching Add Questions Form */
            .questions-section {
                margin-top: 40px;
                background: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .questions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 16px;
                border-bottom: 1px solid #eee;
            }

            .questions-title {
                font-size: 18px;
                font-weight: 600;
                color: #3498db;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .questions-title i {
                color: #3498db;
            }

            .collapse-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                background: #f8f9fa;
                border: 1px solid #ddd;
                border-radius: 6px;
                color: #6c757d;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .collapse-btn:hover {
                background: #e9ecef;
                border-color: #adb5bd;
            }

            .questions-content-area {
                min-height: 200px;
                max-height: 600px;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 20px;
                background: #fafafa;
                transition: all 0.3s ease;
                overflow-y: auto;
                overflow-x: hidden;
            }

            .questions-content-area.collapsed {
                max-height: 0;
                opacity: 0;
                margin: 0;
                padding: 0;
                overflow: hidden;
            }

            .questions-content-area.expanded {
                max-height: 600px;
                opacity: 1;
                overflow-y: auto;
            }

            /* Custom scrollbar for questions area */
            .questions-content-area::-webkit-scrollbar {
                width: 8px;
            }

            .questions-content-area::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            .questions-content-area::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 4px;
            }

            .questions-content-area::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }

            .question-form {
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 12px;
                margin-bottom: 20px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .question-header {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px 20px;
                background: #f8f9fa;
                border-bottom: 1px solid #e9ecef;
                flex-wrap: wrap;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .question-header-actions {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-left: auto;
            }

            .question-header:hover {
                background: #e9ecef;
            }

            .question-number {
                background: #3498db;
                color: white;
                padding: 6px 12px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 14px;
            }

            .question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #2c3e50;
                font-size: 14px;
                font-weight: 500;
            }

            .question-type i {
                color: #27ae60;
                font-size: 16px;
            }

            .question-toggle-btn {
                background: #6c757d;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 10px;
                cursor: pointer;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 12px;
                margin-left: auto;
            }

            .question-toggle-btn:hover {
                background: #5a6268;
            }

            .question-toggle-btn.collapsed {
                background: #28a745;
            }

            .question-toggle-btn.collapsed:hover {
                background: #218838;
            }

            .edit-question-btn {
                background: #f39c12;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: 8px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .edit-question-btn:hover {
                background: #e67e22;
            }

            .question-header .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: 8px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .question-header .delete-question-btn:hover {
                background: #c0392b;
            }

            /* Edit mode styles */
            .question-form.editing {
                border: 2px solid #f39c12;
                box-shadow: 0 4px 12px rgba(243, 156, 18, 0.2);
            }

            .question-form.editing .question-header {
                background: #fef9e7;
                border-bottom-color: #f39c12;
            }

            .btn-save {
                background: #27ae60 !important;
                color: white !important;
            }

            .btn-save:hover {
                background: #229954 !important;
            }

            .remove-option-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 4px 8px;
                cursor: pointer;
                font-size: 12px;
                transition: background-color 0.3s;
            }

            .remove-option-btn:hover {
                background: #c0392b;
            }

            .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                margin-left: auto;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .delete-question-btn:hover {
                background: #c0392b;
            }

            .question-content {
                padding: 20px;
                transition: all 0.3s ease;
                overflow: hidden;
            }

            .question-content.collapsed {
                max-height: 0;
                padding: 0 20px;
                opacity: 0;
            }

            .question-content.expanded {
                max-height: 1000px;
                opacity: 1;
            }

            .question-text {
                font-size: 16px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 16px;
                line-height: 1.5;
            }

            .answer-options {
                margin-bottom: 16px;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 12px;
                padding: 12px 16px;
                border-radius: 8px;
                transition: background-color 0.3s;
                background: #f8f9fa;
                border-left: 4px solid #dee2e6;
            }

            .answer-option:hover {
                background: #e9ecef;
            }

            .answer-option.correct {
                background: #d4edda;
                border-left-color: #28a745;
            }

            .answer-option.incorrect {
                background: #f8d7da;
                border-left-color: #dc3545;
            }

            .correct-answer-label {
                width: 24px;
                height: 24px;
                border: 2px solid #ddd;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s;
                background: white;
            }

            .correct-answer-label.correct {
                background: #28a745;
                border-color: #28a745;
                color: white;
            }

            .correct-answer-label.incorrect {
                background: #dc3545;
                border-color: #dc3545;
                color: white;
            }

            .answer-input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background: white;
            }

            .explanation-group {
                margin-top: 16px;
            }

            .explanation-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: #e3f2fd;
                border-color: #bbdefb;
                color: #1565c0;
                font-style: italic;
            }

            .explanation-input::placeholder {
                color: #90caf9;
            }

            .add-option-btn {
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                cursor: pointer;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: background-color 0.3s;
                margin-bottom: 16px;
            }

            .add-option-btn:hover {
                background: #229954;
            }

            .empty-questions {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px;
                text-align: center;
                color: #6c757d;
            }

            .empty-questions i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #bdc3c7;
            }

            .empty-questions p {
                margin: 0;
                font-size: 16px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .questions-section {
                    padding: 16px;
                    margin-top: 20px;
                }

                .questions-header {
                    flex-direction: column;
                    gap: 12px;
                    align-items: flex-start;
                }

                .question-content {
                    padding: 16px;
                }

                .question-text {
                    font-size: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div id="page" data-courseid="${courseId}"></div>
        <div class="container" style="max-width: 1500px;">
            <a class="back-link" href="manageModule?courseId=${param.courseId}"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <div class="page-title-wrap">
                <h2>Thêm mới bài học dạng video</h2>
            </div>
            <div class="lesson-content-page">
                <!-- Left Sidebar -->
                <aside class="topic-sidebar">
                    <div class="sidebar-search">
                        <input type="text" placeholder="Tìm kiếm">
                        <i class="fas fa-search" style="color: #7f8c8d;"></i>
                    </div>
                    <div class="topic-tree">
                        <c:forEach var="h" items="${requestScope.content}">
                            <div class="module-header" style="position: relative;">
                                <div class="module-title">
                                    <i class="fas fa-folder" style="color: #f39c12;"></i>
                                    ${h.key.title}
                                </div>
                                <div class="module-actions">
                                    <button class="add-lesson-btn" onclick="toggleDropdown('dropdown-${h.key.moduleId}')">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                                <div class="dropdown-menu" id="dropdown-${h.key.moduleId}">
                                    <div class="dropdown-item" onclick="createLesson('video', '${h.key.moduleId}')">
                                        <i class="fas fa-video" style="color: #e74c3c;"></i>
                                        Tạo bài học Video
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('reading', '${h.key.moduleId}')">
                                        <i class="fas fa-file-alt" style="color: #3498db;"></i>
                                        Tạo bài học Reading
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('discussion', '${h.key.moduleId}')">
                                        <i class="fas fa-comments" style="color: #f39c12;"></i>
                                        Tạo Thảo Luận
                                    </div>
                                    <div class="dropdown-item" onclick="createLesson('quiz', '${h.key.moduleId}')">
                                        <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                                        Tạo Quiz
                                    </div>
                                </div>
                            </div>
                            <c:forEach var="item" items="${h.value}">
                                <div class="tree-item ${item.moduleItemId == lesson.moduleItemId ? 'active' : ''}" style="margin-left: 16px;">
                                    <c:choose>
                                        <c:when test="${item.itemType == 'lesson'}">
                                            <a href="updateLesson?courseId=${param.courseId}&moduleId=${h.key.moduleId}&lessonId=${item.moduleItemId}" style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-play" style="color: #e74c3c;"></i>  Bài học #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                        <c:when test="${item.itemType == 'discussion'}">
                                            <a href="updateDiscussion?courseId=${param.courseId}&moduleId=${h.key.moduleId}&discussionId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-comments" style="color: #f39c12;"></i>
                                                Thảo luận #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                        <c:when test="${item.itemType == 'quiz'}">
                                            <a href="updateQuiz?courseId=${param.courseId}&moduleId=${h.key.moduleId}&quizId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                                                Quiz #${item.moduleItemId}
                                            </a>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:forEach>
                    </div>                
                    <div class="guide-section">
                        <div class="guide-label">HƯỚNG DẪN</div>
                        <div class="guide-icon">
                            <i class="fas fa-file-alt" style="color: #3498db;"></i>
                            <span>READING</span>
                        </div>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content" style="height: 800px">
                    <div class="lesson-header">
                        <div class="lesson-title">
                            <a href="module.jsp?courseId=${param.courseId}" class="back-arrow">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            <h1>Cập nhật bài học dạng video</h1>
                        </div>
                        <div class="lesson-actions">
                            <a href="deleteLesson?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}" 
                               class="action-btn delete-lesson-btn"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này không?')">
                                <i class="fas fa-trash"></i>
                                Xóa bài học
                            </a>
                        </div>
                    </div>

                    <form action="updateLesson" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                       <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

                        <div class="lesson-form">
                            <div class="form-group">
                                <label for="lessonTitle">Tên bài học *</label>
                                <input type="text" id="lessonTitle" name="title" value="${lesson.title}" required>
                            </div>

                            <div class="video-container" id="videoContainer">
                                <c:choose>
                                    <c:when test="${not empty lesson.videoUrl}">
                                        <div class="video-wrapper" id="videoWrapper">
                                            <iframe 
                                                src="${lesson.videoUrl}" 
                                                frameborder="0" 
                                                allowfullscreen
                                                class="video-iframe">
                                            </iframe>
                                            <button type="button" class="delete-video-btn" onclick="deleteVideo()" title="Xóa hoặc thay video">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group" id="videoInputGroup">
                                            <label for="videoUrl">Nhập link YouTube *</label>
                                            <input type="text" id="videoUrl" name="videoUrl" placeholder="https://www.youtube.com/watch?v=..." required>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Action Buttons -->


                            <div class="page-actions">
                                <a href="module.jsp?courseId=${param.courseId}" class="btn btn-secondary">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    Lưu
                                </button>
                            </div>
                        </div>
                    </form>
                    <c:if test="${not empty questionMap}">
                        <div class="questions-section" style="margin-top: 60px;">
                            <div class="questions-header">
                                <h3 class="questions-title">
                                    <i class="fas fa-question-circle"></i>
                                    Câu hỏi của bài học
                                </h3>
                                <button class="collapse-btn" onclick="toggleQuestionsCollapse()">
                                    <i class="fas fa-chevron-up"></i>
                                    Thu gọn
                                </button>
                            </div>
                            <div class="questions-content-area expanded" id="questionsContent">
                                <c:forEach var="entry" items="${questionMap}" varStatus="status">
                                    <div class="question-form" data-question-id="${entry.key.questionId}">
                                        <div class="question-header" onclick="toggleQuestionContent('question-${status.index + 1}')">
                                            <div class="question-number">Câu ${status.index + 1}</div>
                                            <div class="question-type">
                                                <i class="fas fa-check-circle"></i>
                                                Trắc nghiệm
                                            </div>
                                            <div class="question-header-actions">
                                                <button class="question-toggle-btn" id="toggle-${status.index + 1}" onclick="event.stopPropagation(); toggleQuestionContent('question-${status.index + 1}')">
                                                    <i class="fas fa-chevron-up"></i>
                                                    Thu gọn
                                                </button>
                                                <button class="edit-question-btn" onclick="event.stopPropagation(); editQuestion('${entry.key.questionId}')">
                                                    <i class="fas fa-edit"></i>
                                                    Chỉnh sửa
                                                </button>
                                                <a href="deleteQuestion?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}&questionId=${entry.key.questionId}"
                                                   class="delete-question-btn"
                                                   style="text-decoration: none;"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?'); event.stopPropagation();">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </a>
                                            </div>
                                        </div>
                                        <div class="question-content expanded" id="question-${status.index + 1}">
                                            <div class="question-text">${entry.key.content}</div>
                                            <div class="answer-options">
                                                <c:forEach var="opt" items="${entry.value}">
                                                    <div class="answer-option ${opt.correct ? 'correct' : 'incorrect'}">
                                                        <div class="correct-answer-label ${opt.correct ? 'correct' : 'incorrect'}">
                                                            <i class="fas ${opt.correct ? 'fa-check' : 'fa-times'}"></i>
                                                        </div>
                                                        <input type="text" class="answer-input" value="${opt.content}" readonly>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <%--<c:if test="${not empty entry.key.explanation}">--%>
                                                <div class="explanation-group">
                                                    <textarea class="explanation-input" readonly>${entry.key.explanation}</textarea>
                                                </div>
                                            <%--</c:if>--%>
                                        </div>
                                    </div>
                                    <form id="updateForm-${entry.key.questionId}" action="updateQuestion" method="post" style="display:none;">
                                        <input type="hidden" name="courseId" value="${param.courseId}">
                                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">
                                        <input type="hidden" name="questionId" value="${entry.key.questionId}">
                                    </form>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <form action="addQuestion" class="add-questions-page" style="margin-top: 60px;" method="post">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

                        <div class="questions-section">
                            <div class="questions-header">
                                <h3 class="questions-title">
                                    <i class="fas fa-plus-circle"></i>
                                    Thêm câu hỏi mới
                                </h3>
                            </div>
                            <div class="questions-content-area expanded">
                                <div id="questionsList">
                                    <div class="empty-questions">
                                        <i class="fas fa-question-circle"></i>
                                        <p>Chưa có câu hỏi nào được thêm</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="actions" style="margin-top: 20px; display: flex; gap: 12px; justify-content: flex-end;">
                            <button type="button" class="btn btn-primary" onclick="addQuestion('mcq_single')">
                                <i class="fas fa-plus"></i> Thêm câu hỏi
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Lưu câu hỏi
                            </button>
                        </div>
                    </form>
                </main>
            </div>
        </div>

        <script>
            let questionCount = 0;
            function toggleDropdown(dropdownId) {
                // Đóng tất cả dropdown khác
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu.id !== dropdownId) {
                        menu.classList.remove('show');
                    }
                });

                // Toggle dropdown hiện tại
                const dropdown = document.getElementById(dropdownId);
                dropdown.classList.toggle('show');
            }

             function createLesson(type, moduleId) {
                var courseId = document.getElementById('page').dataset.courseid || '';
                var url = '';

                if (type === 'video') {
                    url = "ManageLessonServlet?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'reading') {
                    url = "createReadingLesson?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'discussion') {
                    url = "createDiscussion?courseId=" + courseId + "&moduleId=" + moduleId;
                } else if (type === 'quiz') {
                    url = "createQuiz?courseId=" + courseId + "&moduleId=" + moduleId;
                }

                if (url) {
                    window.location.href = url;
                }
            }

            document.addEventListener('click', function (event) {
                if (!event.target.closest('.module-header')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

            function deleteVideo() {
                if (confirm('Bạn có chắc chắn muốn thay video này bằng link mới không?')) {
                    // Xóa phần hiển thị video hiện tại
                    const videoContainer = document.getElementById('videoContainer');
                    videoContainer.innerHTML = `
            <div class="form-group" id="videoInputGroup">
                <label for="videoUrl">Nhập link YouTube *</label>
                <input type="text" id="videoUrl" name="videoUrl" placeholder="https://www.youtube.com/watch?v=..." required>
            </div>
        `;
                }
            }


            function createOptionHTML(questionNumber) {
                var html = "";
                for (var i = 1; i <= 4; i++) {
                    html += '<div class="answer-option">';
                    html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + i + '" ' +
                            'id="correct-' + questionNumber + '-' + i + '" class="correct-answer-checkbox">';
                    html += '    <label for="correct-' + questionNumber + '-' + i + '" class="correct-answer-label">';
                    html += '        <i class="fas fa-check"></i>';
                    html += '    </label>';
                    html += '    <input type="text" name="optionContent' + questionNumber + '_' + i + '" ' +
                            'class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                    html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                    html += '        <i class="fas fa-trash"></i>';
                    html += '    </button>';
                    html += '</div>';
                }
                return html;
            }

            function addQuestion(type) {
                questionCount++;
                var list = document.getElementById("questionsList");
                var empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                var html = '';
                html += '<div class="question-form" id="question-' + questionCount + '" data-question-id="new-' + questionCount + '">';
                html += '    <div class="question-header" onclick="toggleQuestionContent(\'question-' + questionCount + '\')">';
                html += '        <div class="question-number">Câu ' + questionCount + '</div>';
                html += '        <div class="question-type">';
                html += '            <i class="fas fa-check-circle"></i>';
                html += '            Trắc nghiệm';
                html += '        </div>';
                html += '        <div class="question-header-actions">';
                html += '            <button class="question-toggle-btn" id="toggle-' + questionCount + '" onclick="event.stopPropagation(); toggleQuestionContent(\'question-' + questionCount + '\')">';
                html += '                <i class="fas fa-chevron-up"></i>';
                html += '                Thu gọn';
                html += '            </button>';
                html += '            <button type="button" class="delete-question-btn" onclick="event.stopPropagation(); deleteQuestion(' + questionCount + ')">';
                html += '                <i class="fas fa-trash"></i>';
                html += '                Xóa';
                html += '            </button>';
                html += '        </div>';
                html += '    </div>';
                html += '    <div class="question-content expanded">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="' + type + '">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" class="question-input" ' +
                        'placeholder="Nhập nội dung câu hỏi..." required></textarea>';
                html += '        </div>';
                html += '        <div class="answer-options">' + createOptionHTML(questionCount) + '</div>';
                html += '        <button type="button" class="add-option-btn" onclick="addOption(' + questionCount + ')">';
                html += '            <i class="fas fa-plus"></i> Thêm phương án';
                html += '        </button>';
                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" class="explanation-input" ' +
                        'placeholder="Nhập lời giải chi tiết (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                list.insertAdjacentHTML("beforeend", html);
            }

            function deleteQuestion(number) {
                var q = document.getElementById("question-" + number);
                if (q)
                    q.remove();
            }

            function removeOption(button) {
                var optionDiv = button.closest(".answer-option");
                if (optionDiv)
                    optionDiv.remove();
            }

            function addOption(questionNumber) {
                var optionsDiv = document.querySelector("#question-" + questionNumber + " .answer-options");
                var currentCount = optionsDiv.querySelectorAll(".answer-option").length;
                var newIndex = currentCount + 1;

                var html = '';
                html += '<div class="answer-option">';
                html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + newIndex + '" ' +
                        'id="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-checkbox">';
                html += '    <label for="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-label">';
                html += '        <i class="fas fa-check"></i>';
                html += '    </label>';
                html += '    <input type="text" name="optionContent' + questionNumber + '_' + newIndex + '" ' +
                        'class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                html += '        <i class="fas fa-trash"></i>';
                html += '    </button>';
                html += '</div>';

                optionsDiv.insertAdjacentHTML("beforeend", html);
            }

            // Questions collapse/expand functionality
            function toggleQuestionsCollapse() {
                const content = document.getElementById('questionsContent');
                const toggle = document.querySelector('.collapse-btn');

                if (content.classList.contains('expanded')) {
                    content.classList.remove('expanded');
                    content.classList.add('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-down"></i> Mở rộng';
                } else {
                    content.classList.remove('collapsed');
                    content.classList.add('expanded');
                    toggle.innerHTML = '<i class="fas fa-chevron-up"></i> Thu gọn';
                }
            }


            // Toggle individual question content
            function toggleQuestionContent(questionId) {
                const content = document.getElementById(questionId);
                const toggle = document.getElementById('toggle-' + questionId.split('-')[1]);

                if (content.classList.contains('expanded')) {
                    content.classList.remove('expanded');
                    content.classList.add('collapsed');
                    toggle.classList.add('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-down"></i> Mở rộng';
                } else {
                    content.classList.remove('collapsed');
                    content.classList.add('expanded');
                    toggle.classList.remove('collapsed');
                    toggle.innerHTML = '<i class="fas fa-chevron-up"></i> Thu gọn';
                }
            }


            function editQuestion(questionId) {
                const qForm = document.querySelector('[data-question-id="' + questionId + '"]');
                const form = document.getElementById('updateForm-' + questionId);
                const editBtn = qForm.querySelector('.edit-question-btn');

                if (!qForm) {
                    alert("Không tìm thấy câu hỏi này!");
                    return;
                }

                // Nếu đang ở chế độ chỉnh sửa => lưu thay đổi
                if (qForm.classList.contains('editing')) {
                    saveQuestion(qForm, form);
                } else {
                    // Bật chế độ chỉnh sửa
                    enableEdit(qForm, editBtn);
                }
            }

            function enableEdit(qForm, editBtn) {
                qForm.classList.add('editing');
                editBtn.innerHTML = '<i class="fas fa-save"></i> Lưu';
                editBtn.classList.add('btn-save');
                makeQuestionEditable(qForm);
            }

            function saveQuestion(qForm, form) {
                const questionTextInput = qForm.querySelector('.question-input');
                const explanationInput = qForm.querySelector('.explanation-input');

                if (!questionTextInput) {
                    alert("Không tìm thấy ô nhập câu hỏi!");
                    return;
                }

                // Thêm dữ liệu câu hỏi
                addHiddenInput(form, 'questionText', questionTextInput.value);
                addHiddenInput(form, 'explanation', explanationInput ? explanationInput.value : "");

                // Thêm các phương án trả lời (theo format mà UpdateQuestion.java mong đợi)
                qForm.querySelectorAll('.answer-input').forEach((input, i) => {
                    if (input.value.trim()) {
                        addHiddenInput(form, 'optionContent_' + (i + 1), input.value);
                    }
                });

                // Thêm đáp án đúng
                qForm.querySelectorAll('.correct-answer-checkbox:checked').forEach(cb => {
                    addHiddenInput(form, 'correct', cb.value);
                });

                form.submit();
            }

            function addHiddenInput(form, name, value) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }


            function makeQuestionEditable(questionForm) {
                // Chuyển câu hỏi thành textarea
                convertQuestionToTextarea(questionForm);
                
                // Làm cho các phương án có thể chỉnh sửa
                makeOptionsEditable(questionForm);
                
                // Làm cho phần giải thích có thể chỉnh sửa
                makeExplanationEditable(questionForm);
                
                // Thêm nút thêm phương án
                addOptionButton(questionForm);
            }

            function convertQuestionToTextarea(questionForm) {
                const questionText = questionForm.querySelector('.question-text');
                if (questionText) {
                    const textarea = document.createElement('textarea');
                    textarea.className = 'question-input';
                    textarea.value = questionText.textContent;
                    textarea.name = 'editQuestionText';
                    textarea.placeholder = 'Nhập nội dung câu hỏi...';
                    textarea.required = true;
                    questionText.parentNode.replaceChild(textarea, questionText);
                }
            }

            function makeOptionsEditable(questionForm) {
                const answerOptions = questionForm.querySelectorAll('.answer-option');
                answerOptions.forEach((option, index) => {
                    const input = option.querySelector('.answer-input');
                    if (input) {
                        input.removeAttribute('readonly');
                        input.name = 'editOptionContent_' + (index + 1);
                    }

                    // Thêm checkbox chọn đáp án đúng
                    if (!option.querySelector('.correct-answer-checkbox')) {
                        addCorrectAnswerCheckbox(option, index, questionForm);
                    }

                    // Thêm nút xóa phương án
                    if (!option.querySelector('.remove-option-btn')) {
                        addRemoveButton(option);
                    }
                });
            }

            function addCorrectAnswerCheckbox(option, index, questionForm) {
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.name = 'correct';
                checkbox.value = (index + 1);
                checkbox.id = 'edit-correct-' + (index + 1);
                checkbox.className = 'correct-answer-checkbox';

                const label = document.createElement('label');
                label.htmlFor = 'edit-correct-' + (index + 1);
                label.className = 'correct-answer-label';
                label.innerHTML = '<i class="fas fa-check"></i>';

                // Đánh dấu đáp án đúng ban đầu
                if (option.classList.contains('correct')) {
                    checkbox.checked = true;
                    label.classList.add('correct');
                }

                // Xử lý sự kiện click
                label.onclick = function() {
                    toggleCorrectAnswer(checkbox, label, questionForm);
                };

                const input = option.querySelector('.answer-input');
                option.insertBefore(checkbox, input);
                option.insertBefore(label, input);
            }

            function toggleCorrectAnswer(checkbox, label, questionForm) {
                // Bỏ chọn tất cả các đáp án khác
                questionForm.querySelectorAll('.correct-answer-checkbox').forEach(cb => {
                    if (cb !== checkbox) {
                        cb.checked = false;
                        cb.nextElementSibling.classList.remove('correct');
                    }
                });

                // Toggle đáp án hiện tại
                checkbox.checked = !checkbox.checked;
                if (checkbox.checked) {
                    label.classList.add('correct');
                } else {
                    label.classList.remove('correct');
                }
            }

            function addRemoveButton(option) {
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-option-btn';
                removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
                removeBtn.onclick = function() {
                    removeOption(removeBtn);
                };
                option.appendChild(removeBtn);
            }

            function makeExplanationEditable(questionForm) {
                const explanationTextarea = questionForm.querySelector('.explanation-input');
                if (explanationTextarea) {
                    explanationTextarea.removeAttribute('readonly');
                    explanationTextarea.name = 'editExplanation';
                }
            }

            function addOptionButton(questionForm) {
                const answerOptionsContainer = questionForm.querySelector('.answer-options');
                if (answerOptionsContainer && !answerOptionsContainer.querySelector('.add-option-btn')) {
                    const addOptionBtn = document.createElement('button');
                    addOptionBtn.type = 'button';
                    addOptionBtn.className = 'add-option-btn';
                    addOptionBtn.innerHTML = '<i class="fas fa-plus"></i> Thêm phương án';
                    addOptionBtn.onclick = function() {
                        addOptionToEdit(questionForm);
                    };
                    answerOptionsContainer.appendChild(addOptionBtn);
                }
            }

            function makeQuestionReadonly(questionForm) {
                const questionTextarea = questionForm.querySelector('.question-input');
                if (questionTextarea) {
                    const questionText = document.createElement('div');
                    questionText.className = 'question-text';
                    questionText.textContent = questionTextarea.value;
                    questionTextarea.parentNode.replaceChild(questionText, questionTextarea);
                }

                const answerOptions = questionForm.querySelectorAll('.answer-option');
                answerOptions.forEach(function (option) {
                    const input = option.querySelector('.answer-input');
                    if (input) {
                        input.setAttribute('readonly', 'readonly');
                    }

                    // Remove checkbox and label for correct answer selection
                    const checkbox = option.querySelector('.correct-answer-checkbox');
                    const label = option.querySelector('.correct-answer-label');
                    if (checkbox)
                        checkbox.remove();
                    if (label)
                        label.remove();

                    const removeBtn = option.querySelector('.remove-option-btn');
                    if (removeBtn)
                        removeBtn.remove();
                });

                const explanationTextarea = questionForm.querySelector('.explanation-input');
                if (explanationTextarea) {
                    explanationTextarea.setAttribute('readonly', 'readonly');
                }

                const addOptionBtn = questionForm.querySelector('.add-option-btn');
                if (addOptionBtn)
                    addOptionBtn.remove();
            }

            function addOptionToEdit(questionForm) {
                const answerOptionsContainer = questionForm.querySelector('.answer-options');
                const currentCount = answerOptionsContainer.querySelectorAll('.answer-option').length;
                const newIndex = currentCount + 1;

                const optionDiv = document.createElement('div');
                optionDiv.className = 'answer-option';
                
                // Tạo checkbox
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.name = 'correct';
                checkbox.value = newIndex;
                checkbox.id = 'edit-correct-' + newIndex;
                checkbox.className = 'correct-answer-checkbox';
                
                // Tạo label
                const label = document.createElement('label');
                label.htmlFor = 'edit-correct-' + newIndex;
                label.className = 'correct-answer-label';
                label.innerHTML = '<i class="fas fa-check"></i>';
                label.onclick = function() {
                    toggleCorrectAnswer(checkbox, label, questionForm);
                };
                
                // Tạo input text
                const input = document.createElement('input');
                input.type = 'text';
                input.name = 'editOptionContent_' + newIndex;
                input.className = 'answer-input';
                input.placeholder = 'Nhập phương án. Ví dụ: Việt Nam';
                
                // Tạo nút xóa
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-option-btn';
                removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
                removeBtn.onclick = function() {
                    removeOption(removeBtn);
                };
                
                // Thêm các phần tử vào div
                optionDiv.appendChild(checkbox);
                optionDiv.appendChild(label);
                optionDiv.appendChild(input);
                optionDiv.appendChild(removeBtn);

                answerOptionsContainer.insertBefore(optionDiv, answerOptionsContainer.querySelector('.add-option-btn'));
            }
             function toggleCorrectAnswer(clickedLabel) {
                const checkbox = clickedLabel.previousElementSibling;
                const questionForm = clickedLabel.closest('.question-form');

                // Uncheck all other options in this question
                const allCheckboxes = questionForm.querySelectorAll('.correct-answer-checkbox');
                allCheckboxes.forEach(function (cb) {
                    if (cb !== checkbox) {
                        cb.checked = false;
                        cb.nextElementSibling.classList.remove('correct');
                    }
                });

                // Toggle current option
                checkbox.checked = !checkbox.checked;
                if (checkbox.checked) {
                    clickedLabel.classList.add('correct');
                } else {
                    clickedLabel.classList.remove('correct');
                }
            }

        </script>
    </body>
</html>
