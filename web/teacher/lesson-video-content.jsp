<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

            /* Add Questions Form Styles */
            .add-questions-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .questions-content-area {
                min-height: 200px;
                border: 2px dashed #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .empty-questions {
                text-align: center;
                color: #6c757d;
                font-style: italic;
            }

            .actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
                position: relative;
            }

            .dropdown-toggle i {
                transition: transform 0.3s;
            }

            .dropdown-toggle.active i {
                transform: rotate(180deg);
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                min-width: 250px;
                display: none;
                margin-top: 5px;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                padding: 12px 16px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                color: #2c3e50;
                transition: background 0.2s;
                border-bottom: 1px solid #f0f0f0;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background: #f8f9fa;
            }

            .dropdown-item i {
                width: 20px;
                text-align: center;
                font-size: 16px;
            }

            .dropdown-item:first-child i {
                color: #3498db;
            }

            .dropdown-item:last-child i {
                color: #27ae60;
            }

            .btn-success {
                background: #27ae60;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-success:hover {
                background: #229954;
            }

            /* Question Form Styles */
            .question-form, .text-question-form {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .question-header, .text-question-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #dee2e6;
            }

            .question-number, .text-question-number {
                font-weight: 600;
                color: #2c3e50;
                font-size: 16px;
            }

            .text-question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #27ae60;
                font-size: 14px;
                font-weight: 500;
            }

            .text-question-type i {
                color: #27ae60;
            }

            .delete-question-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                cursor: pointer;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 6px;
                transition: background-color 0.3s;
            }

            .delete-question-btn:hover {
                background: #c0392b;
            }

            .question-content, .text-question-content {
                padding: 0;
            }

            .question-input-group {
                margin-bottom: 20px;
            }

            .question-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                resize: vertical;
                min-height: 100px;
                font-family: inherit;
            }

            .question-input:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            .answer-options {
                margin-bottom: 20px;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 12px;
                padding: 12px 16px;
                background: white;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                transition: all 0.3s;
            }

            .answer-option:hover {
                border-color: #3498db;
                box-shadow: 0 2px 4px rgba(52, 152, 219, 0.1);
            }

            .correct-answer-checkbox {
                display: none;
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

            .correct-answer-label:hover {
                border-color: #3498db;
            }

            .correct-answer-checkbox:checked + .correct-answer-label {
                background: #27ae60;
                border-color: #27ae60;
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

            .answer-input:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            .remove-option-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 6px 10px;
                cursor: pointer;
                font-size: 12px;
                transition: background-color 0.3s;
            }

            .remove-option-btn:hover {
                background: #c0392b;
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

            .file-upload-group {
                margin-bottom: 20px;
            }

            .file-upload-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
                font-size: 14px;
            }

            .file-upload-input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background: white;
            }

            .file-info {
                font-size: 12px;
                color: #6c757d;
                margin-top: 4px;
            }

            .answer-group {
                margin-bottom: 20px;
            }

            .answer-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
                font-size: 14px;
            }

            .explanation-group {
                margin-bottom: 20px;
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
                resize: vertical;
                min-height: 80px;
                font-family: inherit;
            }

            .explanation-input::placeholder {
                color: #90caf9;
            }

            .explanation-input:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.2);
            }
            .table-container {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .questions-table {
                width: 100%;
                border-collapse: collapse;
            }

            .questions-table th {
                background: #f8f9fa;
                padding: 16px;
                text-align: left;
                font-weight: 600;
                color: #2c3e50;
                border-bottom: 2px solid #e9ecef;
            }

            .questions-table td {
                padding: 12px 16px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
                font-size: 14px;
            }

            .questions-table tr:hover {
                background: #f8f9fa;
            }

            .question-content {
                max-width: 900px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                line-height: 1.4;
            }


            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .status-draft {
                background: #fff3cd;
                color: #856404;
            }

            .status-submitted {
                background: #d1ecf1;
                color: #0c5460;
            }

            .status-approved {
                background: #d4edda;
                color: #155724;
            }

            .status-rejected {
                background: #f8d7da;
                color: #721c24;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
            }

            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .btn-edit {
                background: #f39c12;
                color: white;
            }

            .btn-edit:hover {
                background: #e67e22;
            }

            .btn-delete {
                background: #e74c3c;
                color: white;
            }

            .btn-delete:hover {
                background: #c0392b;
            }

            .btn-view {
                background: #3498db;
                color: white;
            }

            .btn-view:hover {
                background: #2980b9;
            }

            .btn-warning {
                background: #f39c12;
                color: white;
            }

            .btn-warning:hover {
                background: #e67e22;
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

                .actions {
                    flex-direction: column;
                    align-items: stretch;
                }

                .dropdown {
                    width: 100%;
                }

                .dropdown-toggle {
                    width: 100%;
                    justify-content: center;
                }
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                animation: fadeIn 0.3s ease;
            }

            .modal.show {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background: white;
                border-radius: 12px;
                padding: 30px;
                max-width: 800px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                animation: slideInUp 0.3s ease;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e9ecef;
            }

            .modal-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                color: #6c757d;
                cursor: pointer;
                padding: 5px;
                border-radius: 4px;
                transition: all 0.3s;
            }

            .close-btn:hover {
                background: #f8f9fa;
                color: #2c3e50;
            }

            .modal-body {
                margin-bottom: 25px;
            }

            .modal-footer {
                display: flex;
                gap: 15px;
                justify-content: flex-end;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn-cancel {
                background: #6c757d;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-cancel:hover {
                background: #5a6268;
            }

            .btn-save {
                background: #28a745;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            }

            .btn-save:hover {
                background: #218838;
            }
            .question-form, .text-question-form {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .question-header, .text-question-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #dee2e6;
            }

            .question-number, .text-question-number {
                font-weight: 600;
                color: #2c3e50;
                font-size: 16px;
            }

            .text-question-type {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #27ae60;
                font-size: 14px;
                font-weight: 500;
            }

            .question-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                resize: vertical;
                min-height: 80px;
            }

            .question-input:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .answer-options {
                margin: 15px 0;
            }

            .answer-option {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
                padding: 10px;
                background: white;
                border-radius: 6px;
                border: 1px solid #e9ecef;
            }

            .correct-answer-checkbox {
                display: none;
            }

            .correct-answer-label {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 24px;
                height: 24px;
                border: 2px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .correct-answer-checkbox:checked + .correct-answer-label {
                background: #27ae60;
                border-color: #27ae60;
                color: white;
            }

            .answer-input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .remove-option-btn {
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 6px 10px;
                cursor: pointer;
                font-size: 12px;
            }

            .remove-option-btn:hover {
                background: #c0392b;
            }

            .add-option-btn {
                background: #3498db;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                cursor: pointer;
                font-size: 14px;
                margin-top: 10px;
            }

            .add-option-btn:hover {
                background: #2980b9;
            }

            .file-upload-group {
                margin: 15px 0;
            }

            .file-upload-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .file-upload-input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .file-info {
                font-size: 12px;
                color: #6c757d;
                margin-top: 5px;
            }

            .answer-group {
                margin-bottom: 16px;
            }

            .answer-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #2c3e50;
            }

            .explanation-group {
                margin-top: 15px;
            }

            .explanation-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                resize: vertical;
                min-height: 60px;
            }

            .explanation-input:focus {
                outline: none;
                border-color: #27ae60;
                box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
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
        </style>
    </head>
    <body>
        <c:set var="canEdit" value="${sessionScope.currentCourse.status == 'draft' || sessionScope.currentCourse.status == 'rejected'}" />
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
                                  <c:if test="${canEdit}">
                                        <button class="add-lesson-btn" onclick="toggleModuleDropdown('dropdown-${h.key.moduleId}')">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                  </c:if>
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
                                        <c:when test="${item.itemType == 'assignment'}">
                                            <a href="updateAssignment?courseId=${param.courseId}&moduleId=${h.key.moduleId}&assignmentId=${item.moduleItemId}"
                                               style="text-decoration: none; color: inherit;">
                                                <i class="fas fa-tasks" style="color: #27ae60;"></i>
                                                Assignment #${item.moduleItemId}
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
                          
                            <h1>Cập nhật bài học dạng video</h1>
                        </div>
                        <div class="lesson-actions">
                            <c:if test="${canEdit}">
                                  <a href="deleteLesson?courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}" 
                                   class="action-btn delete-lesson-btn"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa bài học này không?')">
                                    <i class="fas fa-trash"></i>
                                    Xóa bài học
                                </a>
                            </c:if>
                              
                            
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
                                                src="https://www.youtube.com/embed/${lesson.videoUrl}" 
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
                                <a href="manageModule?courseId=${param.courseId}" class="btn btn-secondary">
                                    Hủy bỏ
                                </a>
                                <c:if test="${canEdit}">
                                       <button type="submit" class="btn btn-primary">
                                        Lưu
                                    </button>
                                
                                </c:if>
                                 
                            </div>
                        </div>
                    </form>

                    <div class="table-container" style="margin-top: 100px;">
                        <table class="questions-table">
                            <thead>
                                <tr>

                                    <th>ID</th>
                                    <th>Nội dung câu hỏi</th>
                                    <th>Chủ đề</th>
                                    <th>Loại</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty questionMap}">
                                        <c:forEach var="entry" items="${questionMap}">
                                            <tr>

                                                <td>${entry.key.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${entry.key.content}">
                                                        ${fn:substring(entry.key.content, 0, 50)}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${entry.key.topicId != null}">
                                                            <c:forEach var="topic" items="${topics}">
                                                                <c:if test="${topic.topicId == entry.key.topicId}">
                                                                    ${topic.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${entry.key.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                        <c:when test="${entry.key.type == 'text'}">Tự luận</c:when>
                                                        <c:otherwise>${entry.key.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${entry.key.status}">
                                                        <c:choose>
                                                            <c:when test="${entry.key.status == 'draft'}">Nháp</c:when>
                                                            <c:when test="${entry.key.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${entry.key.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${entry.key.status == 'rejected'}">Từ chối</c:when>
                                                            <c:otherwise>${entry.key.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                 <c:if test="${canEdit}">
                                                <td>
                                                    <a href="#"
                                                       class="btn btn-edit"
                                                       data-id="${entry.key.questionId}"
                                                       data-content="${fn:escapeXml(entry.key.content)}"
                                                       data-type="${entry.key.type}"
                                                       data-explanation="${fn:escapeXml(entry.key.explanation)}"
                                                       data-file="${entry.key.mediaUrl}"
                                                       <c:choose>
                                                           <c:when test="${entry.key.type == 'mcq_single'}">
                                                               data-options="<c:forEach var='opt' items='${entry.value}' varStatus='st'>${fn:escapeXml(opt.content)}|${opt.correct ? 'true' : 'false'}${!st.last ? ',' : ''}</c:forEach>"                                                             
                                                           </c:when>
                                                           <c:when test="${entry.key.type == 'text'}">
                                                               data-answer="${fn:escapeXml(entry.value)}"
                                                           </c:when>
                                                       </c:choose>
                                                       onclick="openEditModal(this)">
                                                        <i class="fas fa-edit"></i> Sửa
                                                    </a>
                                                    <c:if test="${entry.key.status == 'rejected'}">
                                                        <a href="#" 
                                                           class="btn btn-warning"
                                                           data-rejection-reason="${fn:escapeXml(entry.key.reviewComment)}"
                                                           onclick="openRejectionReasonModal(this)">
                                                            <i class="fas fa-exclamation-triangle"></i> Xem lý do
                                                        </a>
                                                    </c:if>
                                                    
                                                        <a href="deleteQuestion?questionId=${entry.key.questionId}&courseId=${param.courseId}&moduleId=${param.moduleId}&lessonId=${lesson.moduleItemId}" 
                                                           class="btn btn-delete" 
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?');">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    
                                                    </div>
                                                </td>
                                        </c:if>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="empty-state">
                                                <i class="fas fa-question-circle"></i>
                                                <p>Chưa có câu hỏi nháp nào</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                   <c:if test="${canEdit}">
                        <!-- Add Questions Form -->
                        <div class="add-questions-form" style="margin-top: 100px;">
                            <h3>Thêm câu hỏi mới</h3>
                            <form action="addQuestion" method="post" enctype="multipart/form-data" id="bulkQuestionForm">
                                <input type="hidden" name="courseId" value="${param.courseId}">
                                <input type="hidden" name="moduleId" value="${param.moduleId}">
                                <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">

                                <div id="questionsList" class="questions-content-area">
                                    <div class="empty-questions">
                                        <p>Chưa có câu hỏi nào được thêm</p>
                                    </div>
                                </div>

                                <div class="actions">
                                    <div class="dropdown">
                                        <button type="button" class="btn btn-primary dropdown-toggle" onclick="toggleQuestionTypeDropdown(this)">
                                            + Thêm câu hỏi
                                            <i class="fas fa-chevron-down"></i>
                                        </button>
                                        <div class="dropdown-menu" id="questionTypeDropdown">
                                            <div class="dropdown-item" onclick="addQuestion('mcq_single')">
                                                <i class="fas fa-check-circle"></i>
                                                Câu hỏi lựa chọn 1 đáp án
                                            </div>
                                            <div class="dropdown-item" onclick="addTextQuestion()">
                                                <i class="fas fa-file-text"></i>
                                                Câu hỏi dạng text
                                            </div>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-success">Lưu tất cả</button>
                                </div>
                            </form>
                        </div>
                   </c:if>
                    
                </main>
            </div>
        </div>

        <!-- Edit Question Modal -->
        <div id="editQuestionModal" class="modal">
            <div class="modal-content">

                <div class="modal-header">
                    <h2 class="modal-title">Chỉnh sửa câu hỏi</h2>
                    <button class="close-btn" onclick="closeEditModal()">&times;</button>
                </div>
                <form id="editQuestionForm" action="updateQuestion" method="post"  enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="courseId" value="${param.courseId}">
                        <input type="hidden" name="moduleId" value="${param.moduleId}">
                        <input type="hidden" name="lessonId" value="${lesson.moduleItemId}">
                        <input type="hidden" id="editQuestionId" name="questionId">
                        <input type="hidden" id="editQuestionType" name="type">

                        <div id="editFilePreview" class="file-upload-group" style="display:none;">
                            <label class="form-label">File đính kèm</label>
                            <div id="filePreviewContainer"></div>

                            <div class="form-group" style="margin-top:10px;">
                                <button type="button" id="deleteFileBtn" class="delete-file-btn" onclick="toggleDeleteFile()">
                                    <i class="fas fa-trash"></i> Xóa file hiện có
                                </button>
                                <input type="hidden" id="deleteFileHidden" name="deleteFile" value="false">
                            </div>
                        </div>
                        <div class="file-upload-group">
                            <label class="form-label">Chọn file mới (nếu muốn thay thế)</label>
                            <input type="file" id="editNewFile" name="newFile" accept="image/*,audio/*">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nội dung câu hỏi *</label>
                            <textarea id="editQuestionContent" name="content" class="form-textarea" placeholder="Nhập nội dung câu hỏi..." required></textarea>
                        </div>



                        <!-- MCQ Options (shown when type is mcq_single) -->
                        <div id="editMcqOptions" class="form-group" style="display: none;">
                            <label class="form-label">Các phương án trả lời</label>
                            <div id="editAnswerOptions">
                                <!-- Options will be dynamically added here -->
                            </div>
                          
                        </div>

                        <!-- Text Answer (shown when type is text) -->
                        <div id="editTextAnswer" class="form-group" style="display: none;">
                            <label class="form-label">Đáp án đúng *</label>
                            <textarea id="editCorrectAnswer" name="correctAnswer" class="form-textarea" placeholder="Nhập đáp án đúng..."></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Giải thích đáp án</label>
                            <textarea id="editQuestionExplanation" name="explanation" class="form-textarea" placeholder="Nhập giải thích cho đáp án..."></textarea>
                        </div>


                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeEditModal()">Hủy</button>
                        <button type="submit" class="btn-save">Lưu thay đổi</button>
                    </div>
                </form>

            </div>
        </div>

        <script>
            let questionCount = 0;

            function toggleModuleDropdown(id) {
                // Đóng tất cả dropdown khác trước
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu.id !== id) {
                        menu.classList.remove('show');
                    }
                });

                // Mở hoặc đóng menu được click
                const dropdown = document.getElementById(id);
                if (dropdown) {
                    dropdown.classList.toggle('show');
                }
            }

            function toggleQuestionTypeDropdown(button) {
                const dropdown = document.getElementById('questionTypeDropdown');
                if (dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                    button.classList.remove('active');
                } else {
                    dropdown.classList.add('show');
                    button.classList.add('active');
                }
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function (event) {
                const isModuleButton = event.target.closest('.add-lesson-btn');
                const isDropdownItem = event.target.closest('.dropdown-item');
                if (!isModuleButton && !isDropdownItem) {
                    document.querySelectorAll('.dropdown-menu[id^="dropdown-"]').forEach(menu => {
                        menu.classList.remove('show');
                    });
                }
            });

// Đóng dropdown của "Thêm câu hỏi" khi click bên ngoài form thêm câu hỏi
            document.addEventListener('click', function (event) {
                const questionDropdown = document.getElementById('questionTypeDropdown');
                const toggleButton = document.querySelector('.add-questions-form .dropdown-toggle');
                if (
                        questionDropdown &&
                        !questionDropdown.contains(event.target) &&
                        !event.target.closest('.add-questions-form .dropdown-toggle')
                        ) {
                    questionDropdown.classList.remove('show');
                    if (toggleButton)
                        toggleButton.classList.remove('active');
                }
            });

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
                let html = "";
                for (let i = 1; i <= 4; i++) {
                    html += '<div class="answer-option">';
                    html += '    <input type="radio" name="correct' + questionNumber + '" value="' + i + '" ';
                    html += '        id="correct-' + questionNumber + '-' + i + '" class="correct-answer-checkbox">';
                    html += '    <label for="correct-' + questionNumber + '-' + i + '" class="correct-answer-label">';
                    html += '        <i class="fas fa-check"></i>';
                    html += '    </label>';
                    html += '    <input type="text" name="optionContent' + questionNumber + '_' + i + '" ';
                    html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                    html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                    html += '        <i class="fas fa-trash"></i>';
                    html += '    </button>';
                    html += '</div>';
                }
                return html;
            }

            function addQuestion(type) {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                // Bắt đầu ghép chuỗi HTML
                let html = '';
                html += '<div class="question-form" id="question-' + questionCount + '">';
                html += '    <div class="question-header">';
                html += '        <div class="question-number">Câu ' + questionCount + '.</div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '        </button>';
                html += '    </div>';

                html += '    <div class="question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="' + type + '">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';

                // Gọi hàm sinh option (vì createOptionHTML trả về HTML)
                html += '        <div class="answer-options">' + createOptionHTML(questionCount) + '</div>';

           

                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept="image/*,audio/*">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: Hình ảnh (JPG, PNG, GIF...) và Âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';

                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                list.insertAdjacentHTML("beforeend", html);
            }

            function addTextQuestion() {
                questionCount++;
                const list = document.getElementById("questionsList");
                const empty = list.querySelector(".empty-questions");
                if (empty)
                    empty.remove();

                // Close dropdown
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');
                dropdown.classList.remove('show');
                toggle.classList.remove('active');

                let html = '';
                html += '<div class="text-question-form" id="question-' + questionCount + '">';
                html += '    <div class="text-question-header">';
                html += '        <div class="text-question-number">Câu ' + questionCount + '.</div>';
                html += '        <div class="text-question-type">';
                html += '            <i class="fas fa-file-text"></i>';
                html += '            Câu hỏi dạng text';
                html += '        </div>';
                html += '        <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                html += '            <i class="fas fa-trash"></i>';
                html += '            Xóa';
                html += '        </button>';
                html += '    </div>';
                html += '    <div class="text-question-content">';
                html += '        <input type="hidden" name="questionType' + questionCount + '" value="text">';
                html += '        <div class="question-input-group">';
                html += '            <textarea name="questionText' + questionCount + '" ';
                html += '                class="question-input" placeholder="Nhập nội dung câu hỏi tại đây..." required></textarea>';
                html += '        </div>';
                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '            <div class="file-info">';
                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';
                html += '        <div class="answer-group">';
                html += '            <label class="answer-label">Đáp án đúng:</label>';
                html += '            <textarea name="correctAnswer' + questionCount + '" ';
                html += '                class="answer-input" placeholder="Nhập đáp án đúng cho câu hỏi này..." required></textarea>';
                html += '        </div>';
                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
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

          

            function openEditModal(button) {
                var id = button.getAttribute("data-id");
                var content = button.getAttribute("data-content") || "";
                var type = button.getAttribute("data-type") || "";
                var explanation = button.getAttribute("data-explanation") || "";
                var optionsStr = button.getAttribute("data-options") || "";
                var answer = button.getAttribute("data-answer") || "";
                var fileUrl = button.getAttribute("data-file") || "";

                document.getElementById("editQuestionId").value = id;
                document.getElementById("editQuestionContent").value = content;
                document.getElementById("editQuestionExplanation").value = explanation;
                document.getElementById("editQuestionType").value = type;

                var mcqOptions = document.getElementById("editMcqOptions");
                var textAnswer = document.getElementById("editTextAnswer");
                var optionsContainer = document.getElementById("editAnswerOptions");
                optionsContainer.innerHTML = "";
                if (type === "mcq_single") {
                    mcqOptions.style.display = "block";
                    textAnswer.style.display = "none";

                    if (optionsStr && optionsStr.trim() !== "") {
                        var pairs = optionsStr.split(",");
                        for (var i = 0; i < pairs.length; i++) {
                            var p = pairs[i].split("|");
                            if (!p[0])
                                continue;
                            var optText = p[0];
                            var correct = (p[1] === "true");
                            var div = document.createElement("div");
                            div.className = "answer-option";
                            var optionId = 'editCorrect-' + i;
                            div.innerHTML =
                                    '<input type="radio" name="correct" value="' + i + '" id="' + optionId + '" class="correct-answer-checkbox" ' + (correct ? "checked" : "") + '>' +
                                    '<label for="' + optionId + '" class="correct-answer-label"><i class="fas fa-check"></i></label>' +
                                    '<input type="text" name="optionContent_' + (i + 1) + '" class="answer-input" value="' + optText + '">';
                            optionsContainer.appendChild(div);
                        }
                    } else {
                        // 4 option mặc định
                        for (var i = 0; i < 4; i++) {
                            var div = document.createElement("div");
                            div.className = "answer-option";
                            var optionId = 'editCorrect-' + i;
                            div.innerHTML =
                                    '<input type="radio" name="correct" value="' + i + '" id="' + optionId + '" class="correct-answer-checkbox">' +
                                    '<label for="' + optionId + '" class="correct-answer-label"><i class="fas fa-check"></i></label>' +
                                    '<input type="text" name="optionContent_' + (i + 1) + '" class="answer-input" placeholder="Nhập phương án ' + (i + 1) + '">';
                            optionsContainer.appendChild(div);
                        }
                    }
                } else if (type === "text") {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "block";
                    document.getElementById("editCorrectAnswer").value = answer;
                } else {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "none";
                }
                var previewWrapper = document.getElementById("editFilePreview");
                var previewContainer = document.getElementById("filePreviewContainer");

                if (fileUrl && fileUrl.trim() !== "") {
                    previewWrapper.style.display = "block";

                    // Lấy đuôi file (extension)
                    var extension = fileUrl.split('.').pop().toLowerCase();

                    // Xác định loại media
                    var isImage = ["jpg", "jpeg", "png", "gif", "bmp", "webp"].includes(extension);
                    var isAudio = ["mp3", "wav", "m4a", "aac", "ogg"].includes(extension);

                    if (isImage) {
                        var html = "";
                        html += '<img src="' + fileUrl + '" alt="Ảnh đính kèm" ';
                        html += 'style="max-width:100%; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">';
                        previewContainer.innerHTML = html;
                    } else if (isAudio) {
                        var html = "";
                        html += '<audio controls style="width:100%;">';
                        html += '<source src="' + fileUrl + '" type="audio/mpeg">';
                        html += 'Trình duyệt của bạn không hỗ trợ phát âm thanh.';
                        html += '</audio>';
                        previewContainer.innerHTML = html;
                    } else {
                        previewContainer.innerHTML = '<p>Không thể hiển thị loại file này.</p>';
                    }
                } else {
                    previewWrapper.style.display = "none";
                    previewContainer.innerHTML = "";
                }
                var modal = document.getElementById("editQuestionModal");
                modal.classList.add("show");
                modal.style.display = "flex";
            }


            function closeEditModal() {
                const modal = document.getElementById('editQuestionModal');
                modal.classList.remove('show');
                modal.style.display = 'none';

                modal.querySelectorAll("input, textarea, select, button").forEach(el => {
                    el.disabled = false;
                });
                document.querySelector("#editQuestionForm .btn-save").style.display = "inline-block";
                const cancelBtn = document.querySelector("#editQuestionForm .btn-cancel");
                cancelBtn.textContent = "Hủy";
            }


       

            function removeEditOption(button) {
                const optionDiv = button.closest('.answer-option');
                if (optionDiv) {
                    optionDiv.remove();
                }
            }

            function toggleDeleteFile() {
                const deleteBtn = document.getElementById('deleteFileBtn');
                const deleteHidden = document.getElementById('deleteFileHidden');
                const filePreview = document.getElementById('editFilePreview');
                const filePreviewContainer = document.getElementById('filePreviewContainer');

                if (deleteHidden.value === 'false') {
                    // First click - show confirmation (don't hide preview yet)
                    deleteBtn.innerHTML = '<i class="fas fa-check"></i> Xác nhận xóa';
                    deleteBtn.classList.add('confirmed');
                    deleteHidden.value = 'true';
                } else {
                    // Second click - actually confirm deletion and hide preview
                    deleteBtn.innerHTML = '<i class="fas fa-trash"></i> Xóa file hiện có';
                    deleteBtn.classList.remove('confirmed');
                    deleteHidden.value = 'false';

                    // Hide file preview when actually confirmed for deletion
                    if (filePreviewContainer) {
                        filePreviewContainer.style.display = 'none';
                    }
                }
            }


        </script>
    </body>
</html>
