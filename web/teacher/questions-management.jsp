

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Câu hỏi</title>
        <link rel="stylesheet" href="css/styles.css">
        <link rel="stylesheet" href="css/course-students.css">
        <link rel="stylesheet" href="css/course-content.css">
        <link rel="stylesheet" href="css/teacher-questions.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                max-width: 1400px;
                margin-left: auto;
                margin-right: auto;
                padding: 0 20px;
            }

            .questions-management-container {
                flex: 1;
                min-width: 0;
            }

            .page-header {
                margin-bottom: 30px;
            }

            .page-title {
                font-size: 28px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .page-subtitle {
                color: #7f8c8d;
                font-size: 16px;
            }

            /* Tab Navigation */
            .tab-navigation {
                display: flex;
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 30px;
            }

            .tab-button {
                padding: 12px 24px;
                background: none;
                border: none;
                font-size: 16px;
                font-weight: 500;
                color: #6c757d;
                cursor: pointer;
                border-bottom: 3px solid transparent;
                transition: all 0.3s ease;
            }

            .tab-button.active {
                color: #2c3e50;
                border-bottom-color: #3498db;
            }

            .tab-button:hover {
                color: #2c3e50;
                background-color: #f8f9fa;
            }

            /* Tab Content */
            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            /* Filter Section */
            .filter-section {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .filter-label {
                font-weight: 500;
                color: #2c3e50;
                font-size: 14px;
            }

            .filter-select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                min-width: 200px;
            }

            .filter-button {
                padding: 8px 16px;
                background: #3498db;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background 0.3s;
            }

            .filter-button:hover {
                background: #2980b9;
            }

            /* Table Styles */
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

            /* Add Question Form */
            .add-question-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #2c3e50;
            }

            .form-input, .form-textarea, .form-select {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .form-textarea {
                min-height: 100px;
                resize: vertical;
            }

            .form-row {
                display: flex;
                gap: 15px;
            }

            .form-row .form-group {
                flex: 1;
            }

            .btn-primary {
                background: #3498db;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
            }

            .btn-primary:hover {
                background: #2980b9;
            }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #dee2e6;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                    gap: 15px;
                }

                .filter-row {
                    flex-direction: column;
                    align-items: stretch;
                }

                .filter-group {
                    width: 100%;
                }

                .filter-select {
                    min-width: auto;
                }

                .form-row {
                    flex-direction: column;
                }

                .action-buttons {
                    flex-wrap: wrap;
                }

                .btn {
                    font-size: 11px;
                    padding: 4px 8px;
                }
            }

            /* Sidebar Integration */
            .admin-sidebar {
                width: 250px;
                flex-shrink: 0;
            }

            .admin-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .admin-menu {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .admin-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 15px;
                color: #6c757d;
                text-decoration: none;
                border-radius: 6px;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
            }

            .admin-link:hover {
                background: #f8f9fa;
                color: #2c3e50;
            }

            .admin-link.active {
                background: #e3f2fd;
                color: #1976d2;
                border-left: 3px solid #1976d2;
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
                gap: 15px;
                align-items: center;
                justify-content: space-between;
            }

            /* Dropdown Styles */
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

            /* Questions Header Styles */
            .questions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .questions-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .questions-actions {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .btn-outline {
                background: transparent;
                color: #6c757d;
                border: 2px solid #6c757d;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-outline:hover {
                background: #6c757d;
                color: white;
            }

            .btn-primary {
                background: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary:hover {
                background: #0056b3;
            }

            /* Checkbox Styles */
            .question-checkbox, #selectAll {
                width: 18px;
                height: 18px;
                cursor: pointer;
                accent-color: #007bff;
            }

            .question-checkbox:checked, #selectAll:checked {
                background-color: #007bff;
            }

            /* Modal Styles */
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

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Simple Pagination Styles */
            .pagination-container {
                display: flex;
                justify-content: center;
                margin: 20px 0;
            }

            .pagination-form {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .pagination-btn {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: #fff;
                color: #333;
                text-decoration: none;
                cursor: pointer;
                border-radius: 4px;
                font-size: 14px;
            }

            .pagination-btn:hover {
                background: #f5f5f5;
            }

            .pagination-btn.active {
                background: #007bff;
                color: #fff;
                border-color: #007bff;
            }

            .pagination-info {
                margin-left: 10px;
                color: #666;
                font-size: 14px;
            }

            /* AI Button Styles */
            .btn-ai {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-ai:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            /* AI Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                animation: fadeIn 0.3s ease;
            }

            .ai-modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 0;
                border-radius: 12px;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                animation: slideIn 0.3s ease;
            }

            .modal-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px 30px;
                border-radius: 12px 12px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .modal-header h3 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .close {
                color: white;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                transition: opacity 0.3s ease;
            }

            .close:hover {
                opacity: 0.7;
            }

            .modal-body {
                padding: 30px;
            }

            /* AI Form Styles - Vertical Layout */
            .ai-form-row {
                margin-bottom: 20px;
            }

            .ai-form-row:last-child {
                margin-bottom: 0;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .form-group label {
                font-weight: 600;
                color: #2c3e50;
                font-size: 14px;
            }

            .form-group select,
            .form-group input,
            .form-group textarea {
                padding: 12px 15px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                background-color: #fff;
            }

            .form-group select:focus,
            .form-group input:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 80px;
                font-family: inherit;
            }

            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                transform: translateY(-1px);
            }

            /* Animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .ai-modal-content {
                    width: 95%;
                    margin: 10% auto;
                }

                .modal-header {
                    padding: 15px 20px;
                }

                .modal-body {
                    padding: 20px;
                }

                .modal-actions {
                    flex-direction: column;
                }

                .modal-actions button {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="dashboard.html" class="brand">
                        <div class="logo"></div>
                        <span>EduPlatform</span>
                    </a>
                    <div class="nav">
                        <a href="instructorDashboard">Dashboard</a>
                        <a href="manage">Khóa học</a>
                        <a href="questions" class="active">Câu hỏi</a>
                    </div>
                    <button class="hamburger">
                        <i class="fas fa-bars"></i>
                    </button>
                </nav>
            </div>
        </header>

        <div class="container">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <div class="questions-management-container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">Quản lý Câu hỏi</h1>
                    <p class="page-subtitle">Quản lý và tạo câu hỏi cho khóa học của bạn</p>
                </div>

                <!-- Tab Navigation -->
                <div class="tab-navigation">
                    <button class="tab-button active" onclick="showTab('question-bank')">
                        Ngân hàng câu hỏi
                    </button>
                    <button class="tab-button" onclick="showTab('questions')">
                        Câu hỏi
                    </button>
                    <button class="tab-button" onclick="showTab('submitted-questions')">
                        Câu hỏi đã tạo
                    </button>
                </div>

                <!-- Question Bank Tab -->
                <div id="question-bank" class="tab-content active">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form method="GET" action="questions">
                            <div class="filter-row">
                                <div class="filter-group">
                                    <label class="filter-label">Lọc theo chủ đề:</label>
                                    <select name="topicId" class="filter-select">
                                        <option value="">Tất cả chủ đề</option>
                                        <c:forEach var="topic" items="${topics}">
                                            <option value="${topic.topicId}" 
                                                    ${selectedTopicId == topic.topicId ? 'selected' : ''}>
                                                ${topic.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="filter-button">
                                    <i class="fas fa-filter"></i> Lọc
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Questions Table -->
                    <div class="table-container">
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
                                    <c:when test="${not empty approvedQuestionMap}">
                                        <c:forEach var="entry" items="${approvedQuestionMap}">
                                            <tr>
                                                <td>${entry.key.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${entry.key.content}">
                                                        ${fn:substring(entry.key.content, 0, 50)}...
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
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-approved">Đã duyệt</span>
                                                </td>
                                                <td>
                                                    <a href="#"
                                                       class="btn btn-view"
                                                       data-id="${entry.key.questionId}"
                                                       data-content="${fn:escapeXml(entry.key.content)}"
                                                       data-type="${entry.key.type}"
                                                       data-explanation="${fn:escapeXml(entry.key.explanation)}"
                                                       data-file="${entry.key.mediaUrl}"
                                                       data-topic="<c:forEach var='topic' items='${topics}'><c:if test='${topic.topicId == entry.key.topicId}'>${topic.name}</c:if></c:forEach>"
                                                       data-status="${entry.key.status}"
                                                       <c:if test="${entry.key.type == 'mcq_single'}">
                                                           data-options="<c:forEach var='opt' items='${entry.value}' varStatus='loop'>${fn:escapeXml(opt.content)}|${opt.correct ? 'true' : 'false'}${!loop.last ? ',' : ''}</c:forEach>"
                                                       </c:if>
                                                       <c:if test="${entry.key.type == 'text'}">
                                                           data-answer="${entry.value}"
                                                       </c:if>
                                                       onclick="openViewQuestion(this)">
                                                        <i class="fas fa-eye"></i> Xem
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="question" items="${allQuestions}">
                                            <tr>
                                                <td>${question.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${question.content}">
                                                        ${fn:substring(question.content, 0, 50)}...
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.topicId != null}">
                                                            <c:forEach var="topic" items="${topics}">
                                                                <c:if test="${topic.topicId == question.topicId}">
                                                                    ${topic.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${question.type == 'mcq_single'}">Trắc nghiệm</c:when>
                                                        <c:when test="${question.type == 'text'}">Tự luận</c:when>
                                                        <c:otherwise>${question.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${question.status}">
                                                        <c:choose>
                                                            <c:when test="${question.status == 'draft'}">Nháp</c:when>
                                                            <c:when test="${question.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${question.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${question.status == 'rejected'}">Từ chối</c:when>
                                                            <c:otherwise>${question.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="#" class="btn btn-view">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                        <a href="#" class="btn btn-edit" 
                                                           data-id="${question.questionId}"
                                                           data-content="${fn:escapeXml(question.content)}"
                                                           data-type="${question.type}"
                                                           data-topic-id="${question.topicId}"
                                                           data-status="${question.status}"
                                                           data-explanation="${fn:escapeXml(question.explanation)}"
                                                           onclick="openEditModal(this)">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </a>
                                                        <a href="#" class="btn btn-delete">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination for All Questions -->
                    <c:if test="${requestScope.totalPages > 1}">
                        <div class="pagination-container">
                            <form action="${pageContext.request.contextPath}/questions" method="get" class="pagination-form">
                                <input type="hidden" name="tab" value="all-questions">
                                <input type="hidden" name="statusFilter" value="${param.statusFilter}">
                                <input type="hidden" name="topicFilter" value="${param.topicFilter}">
                                <input type="hidden" name="keyword" value="${param.keyword}">

                                <c:if test="${requestScope.page > 1}">
                                    <button type="submit" name="page" value="${requestScope.page-1}" class="pagination-btn pagination-nav">«</button>
                                </c:if>

                                <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                                    <button type="submit" name="page" value="${i}"
                                            class="pagination-btn ${i==requestScope.page ? 'active' : ''}">${i}</button>
                                </c:forEach>

                                <c:if test="${requestScope.page < requestScope.totalPages}">
                                    <button type="submit" name="page" value="${requestScope.page+1}" class="pagination-btn pagination-nav">»</button>
                                </c:if>

                                <span class="pagination-info">Trang ${requestScope.page} / ${requestScope.totalPages}</span>
                            </form>
                        </div>
                    </c:if>
                </div>

                <!-- Questions Tab -->
                <div id="questions" class="tab-content">
                    <!-- Questions Header -->
                    <div class="questions-header">
                        <h3 class="questions-title">Câu hỏi của tôi</h3>
                        <div class="questions-actions">
                            <button type="button" class="btn btn-outline" onclick="selectTopic()">
                                <i class="fas fa-tags"></i> Chọn chủ đề
                            </button>
                            <button type="button" class="btn btn-primary" onclick="submitSelected()">
                                <i class="fas fa-paper-plane"></i> Submit
                            </button>
                        </div>
                    </div>

                    <!-- Draft Questions Table -->
                    <div class="table-container">
                        <table class="questions-table">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="selectAll" onchange="toggleAllCheckboxes()">
                                    </th>
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
                                    <c:when test="${not empty draftQuestionMap}">
                                        <c:forEach var="entry" items="${draftQuestionMap}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="question-checkbox" value="${entry.key.questionId}" onchange="updateSelectAll()">
                                                </td>
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
                                                    <a href="deleteQuestion?questionId=${entry.key.questionId}" class="btn btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này không?');">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </a>
                                                    </div>
                                                </td>
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

                    <!-- Pagination for Draft Questions -->
                    <c:if test="${requestScope.draftTotalPages > 1}">
                        <div class="pagination-container">
                            <form action="${pageContext.request.contextPath}/questions" method="get" class="pagination-form">
                                <input type="hidden" name="tab" value="questions">
                                <input type="hidden" name="statusFilter" value="${param.statusFilter}">
                                <input type="hidden" name="topicFilter" value="${param.topicFilter}">
                                <input type="hidden" name="keyword" value="${param.keyword}">

                                <c:if test="${requestScope.draftPage > 1}">
                                    <button type="submit" name="draftPage" value="${requestScope.draftPage-1}" class="pagination-btn pagination-nav">«</button>
                                </c:if>

                                <c:forEach begin="1" end="${requestScope.draftTotalPages}" var="i">
                                    <button type="submit" name="draftPage" value="${i}"
                                            class="pagination-btn ${i==requestScope.draftPage ? 'active' : ''}">${i}</button>
                                </c:forEach>

                                <c:if test="${requestScope.draftPage < requestScope.draftTotalPages}">
                                    <button type="submit" name="draftPage" value="${requestScope.draftPage+1}" class="pagination-btn pagination-nav">»</button>
                                </c:if>

                                <span class="pagination-info">Trang ${requestScope.draftPage} / ${requestScope.draftTotalPages}</span>
                            </form>
                        </div>
                    </c:if>

                    <!-- Add Questions Form -->
                    <div class="add-questions-form">
                        <h3>Thêm câu hỏi mới</h3>
                        <form action="addQuestion" method="post" enctype="multipart/form-data" id="bulkQuestionForm">
                            <div id="questionsList" class="questions-content-area">
                                <div class="empty-questions">
                                    <p>Chưa có câu hỏi nào được thêm</p>
                                </div>
                            </div>

                            <div class="actions">
                                <div class="dropdown">
                                    <button type="button" class="btn btn-primary dropdown-toggle" onclick="toggleDropdown()">
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
                                <button type="button" class="btn btn-ai" onclick="openAIModal()">
                                    <i class="fas fa-robot"></i> Thêm câu hỏi bằng AI
                                </button>
                                <button type="submit" class="btn btn-success">Lưu tất cả</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Submitted Questions Tab -->
                <div id="submitted-questions" class="tab-content">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form method="GET" action="questions">
                            <input type="hidden" name="tab" value="submitted-questions">
                            <div class="filter-row">
                                <div class="filter-group">
                                    <label class="filter-label">Lọc theo trạng thái:</label>
                                    <select name="statusFilter" class="filter-select">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="submitted" ${selectedStatus == 'submitted' ? 'selected' : ''}>Đã gửi</option>
                                        <option value="approved" ${selectedStatus == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                        <option value="rejected" ${selectedStatus == 'rejected' ? 'selected' : ''}>Từ chối</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label class="filter-label">Lọc theo chủ đề:</label>
                                    <select name="topicFilter" class="filter-select">
                                        <option value="">Tất cả chủ đề</option>
                                        <c:forEach var="topic" items="${topics}">
                                            <option value="${topic.topicId}" ${selectedTopic == topic.topicId ? 'selected' : ''}>
                                                ${topic.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="filter-button">
                                    <i class="fas fa-filter"></i> Lọc
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Submitted Questions Table -->
                    <div class="table-container">
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
                                    <c:when test="${not empty submittedQuestions}">
                                        <c:forEach var="entry" items="${submittedQuestions}">
                                            <tr>
                                                <td>${entry.key.questionId}</td>
                                                <td>
                                                    <div class="question-content" title="${entry.key.content}">
                                                        ${fn:substring(entry.key.content, 0, 50)}...
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
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${entry.key.status}">
                                                        <c:choose>
                                                            <c:when test="${entry.key.status == 'submitted'}">Đã gửi</c:when>
                                                            <c:when test="${entry.key.status == 'approved'}">Đã duyệt</c:when>
                                                            <c:when test="${entry.key.status == 'rejected'}">Từ chối</c:when>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="#"
                                                           class="btn btn-view"
                                                           data-id="${entry.key.questionId}"
                                                           data-content="${fn:escapeXml(entry.key.content)}"
                                                           data-type="${entry.key.type}"
                                                           data-explanation="${fn:escapeXml(entry.key.explanation)}"
                                                           data-file="${entry.key.mediaUrl}"
                                                           data-topic="<c:forEach var='topic' items='${topics}'><c:if test='${topic.topicId == entry.key.topicId}'>${topic.name}</c:if></c:forEach>"
                                                           data-status="${entry.key.status}"
                                                           <c:if test="${entry.key.type == 'mcq_single'}">
                                                               data-options="<c:forEach var='opt' items='${entry.value}' varStatus='loop'>${fn:escapeXml(opt.content)}|${opt.correct ? 'true' : 'false'}${!loop.last ? ',' : ''}</c:forEach>"
                                                           </c:if>
                                                           <c:if test="${entry.key.type == 'text'}">
                                                               data-answer="${entry.value}"
                                                           </c:if>
                                                           onclick="openViewQuestion(this)">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>

                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="empty-state">
                                                <i class="fas fa-inbox"></i>
                                                <p>Chưa có câu hỏi nào được submit</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination for Submitted Questions -->
                    <c:if test="${requestScope.submittedTotalPages > 1}">
                        <div class="pagination-container">
                            <form action="${pageContext.request.contextPath}/questions" method="get" class="pagination-form">
                                <input type="hidden" name="tab" value="submitted-questions">
                                <input type="hidden" name="statusFilter" value="${param.statusFilter}">
                                <input type="hidden" name="topicFilter" value="${param.topicFilter}">
                                <input type="hidden" name="keyword" value="${param.keyword}">

                                <c:if test="${requestScope.submittedPage > 1}">
                                    <button type="submit" name="submittedPage" value="${requestScope.submittedPage-1}" class="pagination-btn pagination-nav">«</button>
                                </c:if>

                                <c:forEach begin="1" end="${requestScope.submittedTotalPages}" var="i">
                                    <button type="submit" name="submittedPage" value="${i}"
                                            class="pagination-btn ${i==requestScope.submittedPage ? 'active' : ''}">${i}</button>
                                </c:forEach>

                                <c:if test="${requestScope.submittedPage < requestScope.submittedTotalPages}">
                                    <button type="submit" name="submittedPage" value="${requestScope.submittedPage+1}" class="pagination-btn pagination-nav">»</button>
                                </c:if>

                                <span class="pagination-info">Trang ${requestScope.submittedPage} / ${requestScope.submittedTotalPages}</span>
                            </form>
                        </div>
                    </c:if>
                </div>
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
                            <button type="button" class="add-option-btn" onclick="addEditOption()">
                                <i class="fas fa-plus"></i> Thêm phương án
                            </button>
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

        <div id="topicModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Chọn chủ đề cho câu hỏi</h2>
                    <button type="button" class="close-btn" onclick="closeTopicModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Chủ đề:</label>
                        <select id="topicSelect" class="form-select">
                            <option value="">-- Chọn chủ đề --</option>
                            <c:forEach var="topic" items="${topics}">
                                <option value="${topic.topicId}">${topic.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <p id="selectedCount">Chưa chọn câu hỏi nào</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeTopicModal()">Hủy</button>
                    <button type="button" class="btn-save" onclick="submitAssignTopic()">Gán chủ đề</button>
                </div>
            </div>
        </div>

        <form id="assignTopicForm" action="assignTopic" method="post">
            <input type="hidden" name="questionIds" id="hiddenQuestionIds">
            <input type="hidden" name="topicId" id="hiddenTopicId">
        </form>
        <form id="submitQuestionsForm" action="submitQuestions" method="post">
            <input type="hidden" name="questionIds" id="submitQuestionIds">
        </form>

        <!-- Rejection Reason Modal -->
        <div id="rejectionReasonModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">
                        <i class="fas fa-exclamation-triangle" style="color: #e74c3c; margin-right: 10px;"></i>
                        Lý do từ chối câu hỏi
                    </h2>
                    <button class="close-btn" onclick="closeRejectionReasonModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="rejection-reason-content">
                        <div class="rejection-icon">
                            <i class="fas fa-times-circle" style="font-size: 48px; color: #e74c3c; margin-bottom: 20px;"></i>
                        </div>
                        <div class="rejection-text">
                            <p style="font-size: 16px; line-height: 1.6; color: #2c3e50; margin: 0;">
                                <span id="rejectionReasonText">Đang tải lý do từ chối...</span>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeRejectionReasonModal()">Đóng</button>
                </div>
            </div>
        </div>



        <div id="aiResultContainer" style="margin-top: 20px;"></div>

        <script>

            let questionCount = 0;

            function showTab(tabName) {
                // Hide all tab contents
                const tabContents = document.querySelectorAll('.tab-content');
                tabContents.forEach(content => {
                    content.classList.remove('active');
                });

                // Remove active class from all tab buttons
                const tabButtons = document.querySelectorAll('.tab-button');
                tabButtons.forEach(button => {
                    button.classList.remove('active');
                });

                // Show selected tab content
                document.getElementById(tabName).classList.add('active');

                // Add active class to clicked button
                event.target.classList.add('active');
            }

            function generateAIQuestions(event) {
                event.preventDefault();
                var topic = document.getElementById("aiTopic").value;
                var count = document.getElementById("aiCount").value;
                var type = document.getElementById("aiType").value;
                var resultContainer = document.getElementById("aiResultContainer");

                // Hiện thông báo đang tạo
                resultContainer.innerHTML =
                        '<div style="color: #555; display:flex; align-items:center; gap:10px;">'
                        + '<i class="fas fa-spinner fa-spin"></i>'
                        + '<span>⏳ Đang tạo câu hỏi bằng AI, vui lòng chờ trong giây lát...</span>'
                        + '</div>';
                var submitBtn = document.querySelector("#aiForm button[type='submit']");
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo...';

                fetch("generateQuestionAI", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "topicId=" + encodeURIComponent(topic)
                            + "&count=" + count
                            + "&type=" + type
                })
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (data) {
                            const list = document.getElementById("questionsList");
                            const empty = list.querySelector(".empty-questions");
                            if (empty)
                                empty.remove();

                            for (var i = 0; i < data.length; i++) {
                                var q = data[i];
                                questionCount++;

                                // tạo HTML giống addQuestion
                                let html = '';
                                html += '<div class="question-form" id="question-' + questionCount + '">';
                                html += '  <div class="question-header">';
                                html += '    <div class="question-number">Câu ' + questionCount + '.</div>';
                                html += '    <button type="button" class="delete-question-btn" onclick="deleteQuestion(' + questionCount + ')">';
                                html += '      <i class="fas fa-trash"></i>';
                                html += '    </button>';
                                html += '  </div>';
                                html += '  <div class="question-content">';
                                html += '    <input type="hidden" name="questionType' + questionCount + '" value="' + (q.type === "mcq" ? "mcq_single" : "text") + '">';
                                html += '    <div class="question-input-group">';
                                html += '      <textarea name="questionText' + questionCount + '" class="question-input" required>'
                                        + q.content + '</textarea>';
                                html += '    </div>';

                                if (q.type === "mcq" && q.options) {
                                    html += '  <div class="answer-options">';
                                    for (var j = 0; j < q.options.length; j++) {
                                        var opt = q.options[j];
                                        html += '    <div class="answer-option">';
                                        html += '      <input type="checkbox" name="correct' + questionCount + '" value="' + (j + 1) + '" '
                                                + (opt.isCorrect ? "checked" : "") + '>';
                                        html += '      <input type="text" name="optionContent' + questionCount + '_' + (j + 1) + '" '
                                                + 'class="answer-input" value="' + opt.content + '">';
                                        html += '      <button type="button" class="remove-option-btn" onclick="removeOption(this)"><i class="fas fa-trash"></i></button>';
                                        html += '    </div>';
                                    }
                                    html += '  </div>';
                                } else if (q.type === "text" && q.textKey) {
                                    html += '  <div class="answer-group">';
                                    html += '    <label>Đáp án đúng:</label>';
                                    html += '    <textarea name="correctAnswer' + questionCount + '" class="answer-input" required>'
                                            + q.textKey.answerText + '</textarea>';
                                    html += '  </div>';
                                }

                                html += '  <div class="explanation-group">';
                                html += '    <textarea name="explanation' + questionCount + '" class="explanation-input">'
                                        + (q.explanation ? q.explanation : '') + '</textarea>';
                                html += '  </div>';
                                html += '</div></div>';

                                list.insertAdjacentHTML("beforeend", html);
                            }

                            // Hiển thị thông báo nhỏ
                            resultContainer.innerHTML =
                                    '<div style="color: green; display:flex; align-items:center; gap:10px;">'
                                    + '<i class="fas fa-check-circle"></i>'
                                    + '<span>✅ Đã thêm ' + data.length + ' câu hỏi từ AI vào form thành công!</span>'
                                    + '</div>';

                            submitBtn.disabled = false;
                            submitBtn.innerHTML = '<i class="fas fa-magic"></i> Sinh câu hỏi bằng AI';
                        });
            }
            // Dropdown functions
            function toggleDropdown() {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                } else {
                    dropdown.classList.add('show');
                    toggle.classList.add('active');
                }
            }

            // Close dropdown when clicking outside
            window.onclick = function (event) {
                const dropdown = document.getElementById('questionTypeDropdown');
                const toggle = document.querySelector('.dropdown-toggle');

                if (!event.target.closest('.dropdown')) {
                    dropdown.classList.remove('show');
                    toggle.classList.remove('active');
                }
            };

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

                html += '        <button type="button" class="add-option-btn" onclick="addOption(' + questionCount + ')">';
                html += '            <i class="fas fa-plus"></i> Thêm phương án';
                html += '        </button>';

                html += '        <div class="file-upload-group">';
                html += '            <label class="file-upload-label" for="file' + questionCount + '">Đính kèm file (tùy chọn)</label>';
                html += '            <input type="file" id="file' + questionCount + '" name="file' + questionCount + '" ';
//                html += '                class="file-upload-input" accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png,.gif,.mp4,.avi,.mov,.wmv,.mp3,.wav,.m4a,.aac">';
                html += '                class="file-upload-input" accept="image/*,audio/*">';
                html += '            <div class="file-info">';
//                html += '                Hỗ trợ: PDF, Word, Text, hình ảnh (JPG, PNG, GIF), video (MP4, AVI, MOV, WMV), âm thanh (MP3, WAV, M4A, AAC)';
                html += '                Hỗ trợ: Hình ảnh (JPG, PNG, GIF...) và Âm thanh (MP3, WAV, M4A, AAC)';
                html += '            </div>';
                html += '        </div>';

                html += '        <div class="explanation-group">';
                html += '            <textarea name="explanation' + questionCount + '" ';
                html += '                class="explanation-input" placeholder="Nhập lời giải chi tiết tại đây (nếu có)"></textarea>';
                html += '        </div>';
                html += '    </div>';
                html += '</div>';

                // Thêm vào danh sách
                list.insertAdjacentHTML("beforeend", html);
            }

            function deleteQuestion(number) {
                // Xóa toàn bộ phần câu hỏi theo id
                var question = document.getElementById("question-" + number);
                if (question) {
                    question.remove();
                }
            }

            function removeOption(button) {
                
                var optionDiv = button.closest(".answer-option");
                if (optionDiv) {
                    optionDiv.remove();
                }
            }

            function addOption(questionNumber) {
                var optionsDiv = document.querySelector("#question-" + questionNumber + " .answer-options");
                var currentCount = optionsDiv.querySelectorAll(".answer-option").length;
                var newIndex = currentCount + 1;

                var html = '';
                html += '<div class="answer-option">';
                html += '    <input type="checkbox" name="correct' + questionNumber + '" value="' + newIndex + '" ';
                html += '        id="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-checkbox">';
                html += '    <label for="correct-' + questionNumber + '-' + newIndex + '" class="correct-answer-label">';
                html += '        <i class="fas fa-check"></i>';
                html += '    </label>';
                html += '    <input type="text" name="optionContent' + questionNumber + '_' + newIndex + '" ';
                html += '        class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">';
                html += '    <button type="button" class="remove-option-btn" onclick="removeOption(this)">';
                html += '        <i class="fas fa-trash"></i>';
                html += '    </button>';
                html += '</div>';

                optionsDiv.insertAdjacentHTML("beforeend", html);
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


            function addEditOption() {
                const optionsContainer = document.getElementById('editAnswerOptions');
                const optionCount = optionsContainer.children.length + 1;

                const optionDiv = document.createElement('div');
                optionDiv.className = 'answer-option';
                optionDiv.innerHTML = `
                    <input type="checkbox" name="editCorrect${optionCount}" value="${optionCount}" 
                           id="editCorrect-${optionCount}" class="correct-answer-checkbox">
                    <label for="editCorrect-${optionCount}" class="correct-answer-label">
                        <i class="fas fa-check"></i>
                    </label>
                    <input type="text" name="editOptionContent${optionCount}" 
                           class="answer-input" placeholder="Nhập phương án. Ví dụ: Việt Nam">
                    <button type="button" class="remove-option-btn" onclick="removeEditOption(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                `;

                optionsContainer.appendChild(optionDiv);
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



            // Close modal when clicking outside
            window.onclick = function (event) {
                const modal = document.getElementById('editQuestionModal');
                if (event.target === modal) {
                    closeEditModal();
                }
            };

            // Handle question type change in modal
            document.addEventListener('DOMContentLoaded', function () {
                const typeSelect = document.getElementById('editQuestionType');
                if (typeSelect) {
                    typeSelect.addEventListener('change', function () {
                        toggleEditQuestionType(this.value);
                    });
                }
            });

            // Checkbox functionality
            function toggleAllCheckboxes() {
                const selectAll = document.getElementById('selectAll');
                const checkboxes = document.querySelectorAll('.question-checkbox');

                checkboxes.forEach(checkbox => {
                    checkbox.checked = selectAll.checked;
                });
            }

            function updateSelectAll() {
                const selectAll = document.getElementById('selectAll');
                const checkboxes = document.querySelectorAll('.question-checkbox');
                const checkedBoxes = document.querySelectorAll('.question-checkbox:checked');

                if (checkedBoxes.length === 0) {
                    selectAll.checked = false;
                    selectAll.indeterminate = false;
                } else if (checkedBoxes.length === checkboxes.length) {
                    selectAll.checked = true;
                    selectAll.indeterminate = false;
                } else {
                    selectAll.checked = false;
                    selectAll.indeterminate = true;
                }
            }




            function assignTopic() {
                const topicId = document.getElementById('topicSelect').value;
                const selectedQuestions = getSelectedQuestions();

                if (!topicId) {
                    alert('Vui lòng chọn chủ đề!');
                    return;
                }

                if (selectedQuestions.length === 0) {
                    alert('Không có câu hỏi nào được chọn!');
                    return;
                }

                // Here you would typically send the data to the server
                alert(`Đã gán chủ đề cho ${selectedQuestions.length} câu hỏi!`);
                closeTopicModal();

                // Uncheck all checkboxes
                document.querySelectorAll('.question-checkbox').forEach(cb => cb.checked = false);
                document.getElementById('selectAll').checked = false;
            }

            function submitSelected() {
                const selected = getSelectedQuestions();
                if (selected.length === 0) {
                    alert('Vui lòng chọn ít nhất một câu hỏi!');
                    return;
                }

                // Lấy toàn bộ hàng <tr> trong bảng để kiểm tra topic
                const rows = document.querySelectorAll('.questions-table tbody tr');
                let hasMissingTopic = false;
                let noTopicIds = [];

                selected.forEach(id => {
                    rows.forEach(row => {
                        const idCell = row.querySelector('td:nth-child(2)');
                        if (idCell && idCell.textContent.trim() === id) {
                            const topicCell = row.querySelector('td:nth-child(4)');
                            if (topicCell && topicCell.textContent.includes("Không có")) {
                                hasMissingTopic = true;
                                noTopicIds.push(id);
                            }
                        }
                    });
                });

                if (hasMissingTopic) {
                    alert("❌ Không thể submit!\nCác câu hỏi sau chưa có chủ đề:\n" + noTopicIds.join(", "));
                    return;
                }

                if (confirm(`Bạn có chắc chắn muốn submit ${selected.length} câu hỏi?`)) {
                    document.getElementById('submitQuestionIds').value = selected.join(",");
                    document.getElementById('submitQuestionsForm').submit();
                }
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                console.log('Questions management page loaded');
            });
            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const activeTab = urlParams.get('tab');

                if (activeTab === 'questions') {
                    showTab('questions');
                } else if (activeTab === 'submitted-questions') {
                    showTab('submitted-questions');
                } else {
                    showTab('question-bank');
                }
            });

            function getSelectedQuestions() {
                const checkboxes = document.querySelectorAll('.question-checkbox:checked');
                return Array.from(checkboxes).map(cb => cb.value);
            }

// Mở modal (chỉ thay đổi hiển thị, không tạo HTML)
            function selectTopic() {
                const selected = getSelectedQuestions();
                if (selected.length === 0) {
                    alert('Vui lòng chọn ít nhất một câu hỏi!');
                    return;
                }
                document.getElementById('topicModal').classList.add('show');
                document.getElementById('topicModal').style.display = 'flex';
                document.getElementById('selectedCount').textContent = `Đã chọn ${selected.length} câu hỏi`;
            }

            function closeTopicModal() {
                const modal = document.getElementById('topicModal');
                modal.classList.remove('show');
                modal.style.display = 'none';
            }

// Submit form (không AJAX)
            function submitAssignTopic() {
                const topicId = document.getElementById('topicSelect').value;
                const selectedQuestions = getSelectedQuestions();

                if (!topicId) {
                    alert("Vui lòng chọn chủ đề!");
                    return;
                }

                if (selectedQuestions.length === 0) {
                    alert("Không có câu hỏi nào được chọn!");
                    return;
                }

                document.getElementById("hiddenTopicId").value = topicId;
                document.getElementById("hiddenQuestionIds").value = selectedQuestions.join(",");
                document.getElementById("assignTopicForm").submit();
            }

            function openViewQuestion(button) {
                const id = button.getAttribute("data-id");
                const content = button.getAttribute("data-content") || "";
                const type = button.getAttribute("data-type") || "";
                const explanation = button.getAttribute("data-explanation") || "";
                const fileUrl = button.getAttribute("data-file") || "";
                const topicName = button.getAttribute("data-topic") || "Không có";
                const status = button.getAttribute("data-status") || "";
                const optionsStr = button.getAttribute("data-options") || "";
                const answerText = button.getAttribute("data-answer") || "";

                const modal = document.getElementById("editQuestionModal");
                modal.classList.add("show");
                modal.style.display = "flex";

                // Gán nội dung
                document.getElementById("editQuestionId").value = id;
                document.getElementById("editQuestionContent").value = content;
                document.getElementById("editQuestionExplanation").value = explanation;
                document.getElementById("editQuestionType").value = type;

                const mcqOptions = document.getElementById("editMcqOptions");
                const textAnswer = document.getElementById("editTextAnswer");
                const optionsContainer = document.getElementById("editAnswerOptions");
                optionsContainer.innerHTML = "";

                if (type === "mcq_single") {
                    mcqOptions.style.display = "block";
                    textAnswer.style.display = "none";

                    if (optionsStr.trim() !== "") {
                        const pairs = optionsStr.split(",");
                        pairs.forEach(function (p, index) {
                            const parts = p.split("|");
                            const optText = parts[0];
                            const isCorrect = parts[1] === "true";

                            var html = "";
                            html += '<div class="answer-option">';
                            html += '<input type="radio" disabled ' + (isCorrect ? "checked" : "") + '>';
                            html += '<input type="text" class="answer-input" value="' + optText + '" disabled ';
                            html += 'style="background:' + (isCorrect ? '#d4edda' : 'white') + ';">';
                            if (isCorrect) {
                                html += '<span style="color:green;font-weight:500;">✔</span>';
                            }
                            html += '</div>';

                            optionsContainer.innerHTML += html;
                        });
                    }
                } else if (type === "text") {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "block";
                    document.getElementById("editCorrectAnswer").value = answerText;
                } else {
                    mcqOptions.style.display = "none";
                    textAnswer.style.display = "none";
                }

                // Hiển thị file nếu có
                const previewWrapper = document.getElementById("editFilePreview");
                const previewContainer = document.getElementById("filePreviewContainer");

                if (fileUrl && fileUrl.trim() !== "") {
                    previewWrapper.style.display = "block";
                    const ext = fileUrl.split('.').pop().toLowerCase();

                    var fileHtml = "";
                    if (["jpg", "jpeg", "png", "gif", "webp"].includes(ext)) {
                        fileHtml += '<img src="' + fileUrl + '" style="max-width:100%;border-radius:8px;">';
                    } else if (["mp3", "wav", "m4a", "aac"].includes(ext)) {
                        fileHtml += '<audio controls style="width:100%;">';
                        fileHtml += '<source src="' + fileUrl + '" type="audio/mpeg">';
                        fileHtml += '</audio>';
                    } else {
                        fileHtml += '<p>Không thể xem trước loại file này.</p>';
                    }
                    previewContainer.innerHTML = fileHtml;
                } else {
                    previewWrapper.style.display = "none";
                    previewContainer.innerHTML = "";
                }

                // Khóa input (readonly mode)
                modal.querySelectorAll("input, textarea, select, button").forEach(function (el) {
                    if (el.type !== "button" && el.type !== "hidden") {
                        el.disabled = true;
                    }
                });

                document.querySelector("#editQuestionForm .btn-save").style.display = "none";
                const cancelBtn = document.querySelector("#editQuestionForm .btn-cancel");
                cancelBtn.textContent = "Đóng";
            }

            function openRejectionReasonModal(button) {
                const rejectionReason = button.getAttribute("data-rejection-reason") || "Không có lý do cụ thể được cung cấp.";

                document.getElementById("rejectionReasonText").textContent = rejectionReason;

                const modal = document.getElementById("rejectionReasonModal");
                modal.classList.add("show");
                modal.style.display = "flex";
            }

            function closeRejectionReasonModal() {
                const modal = document.getElementById("rejectionReasonModal");
                modal.classList.remove("show");
                modal.style.display = "none";
            }

            // Close rejection modal when clicking outside
            window.addEventListener('click', function (event) {
                const modal = document.getElementById('rejectionReasonModal');
                if (event.target === modal) {
                    closeRejectionReasonModal();
                }
            });

            // AI Modal Functions
            function openAIModal() {
                document.getElementById('aiModal').style.display = 'block';
                document.body.style.overflow = 'hidden'; // Prevent background scrolling
            }

            function closeAIModal() {
                document.getElementById('aiModal').style.display = 'none';
                document.body.style.overflow = 'auto'; // Restore scrolling
                // Reset form
                document.getElementById('aiForm').reset();
            }

            // Close AI modal when clicking outside
            window.addEventListener('click', function (event) {
                const aiModal = document.getElementById('aiModal');
                if (event.target === aiModal) {
                    closeAIModal();
                }
            });

//        

        </script>

        <!-- AI Question Generation Modal -->
        <div id="aiModal" class="modal">
            <div class="modal-content ai-modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-robot"></i> Tạo câu hỏi tự động bằng AI (Gemini)</h3>
                    <span class="close" onclick="closeAIModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="aiForm" onsubmit="generateAIQuestions(event)">
                        <div class="ai-form-row">
                            <div class="form-group">
                                <label for="aiTopic">Chủ đề:</label>
                                <select id="aiTopic" name="topicId" required>
                                    <option value="">-- Chọn chủ đề --</option>
                                    <c:forEach var="topic" items="${topics}">
                                        <option value="${topic.name}">${topic.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="ai-form-row">
                            <div class="form-group">
                                <label for="aiCount">Số lượng câu hỏi:</label>
                                <input type="number" id="aiCount" name="count" min="1" max="5" value="3" required>
                            </div>
                        </div>

                        <div class="ai-form-row">
                            <div class="form-group">
                                <label for="aiType">Dạng câu hỏi:</label>
                                <select id="aiType" name="type" required>
                                    <option value="mcq">Trắc nghiệm</option>
                                    <option value="text">Tự luận</option>
                                </select>
                            </div>
                        </div>
                        <div id="aiResultContainer" style="margin-top: 20px;"></div>

                        <div class="modal-actions">
                            <button type="button" class="btn btn-secondary" onclick="closeAIModal()">Hủy</button>
                            <button type="submit" class="btn btn-ai">
                                <i class="fas fa-magic"></i> Sinh câu hỏi bằng AI
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
