<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<div class="space-y-6">
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
            <h1 class="text-3xl font-bold text-foreground">Content Management</h1>
            <p class="text-muted-foreground mt-1">Manage learning materials and resources</p>
        </div>
        <button id="addContentBtn" class="bg-primary text-primary-foreground px-4 py-2 rounded-md hover:opacity-90 transition-opacity inline-flex items-center gap-2 font-medium shadow-sm">
            <i data-lucide="plus" class="h-4 w-4"></i>
            Add New Content
        </button>
    </div>

    <div class="bg-card p-6 rounded-lg shadow-sm border border-border">
        <h2 class="text-xl font-semibold mb-4 text-foreground">All Learning Content</h2>
        
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="border-b border-border">
                        <th class="text-left py-3 px-4 font-semibold text-foreground">Title</th>
                        <th class="text-left py-3 px-4 font-semibold text-foreground hidden sm:table-cell">Type</th>
                        <th class="text-left py-3 px-4 font-semibold text-foreground hidden md:table-cell">Description</th>
                        <th class="text-right py-3 px-4 font-semibold text-foreground">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${contents}">
                        <tr data-id="${item.id}" class="border-b border-border hover:bg-secondary/50 transition-colors">
                            <td class="py-4 px-4">
                                <div class="flex items-center gap-2">
                                    <c:choose>
                                        <c:when test="${item.type == 'Video'}">
                                            <i data-lucide="play-circle" class="h-4 w-4 text-muted-foreground"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i data-lucide="file-text" class="h-4 w-4 text-muted-foreground"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="font-medium">${item.title}</span>
                                </div>
                                <p class="text-sm text-muted-foreground mt-1 sm:hidden">${item.description}</p>
                            </td>
                            <td class="py-4 px-4 hidden sm:table-cell">
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-secondary text-secondary-foreground">${item.type}</span>
                            </td>
                            <td class="py-4 px-4 hidden md:table-cell text-muted-foreground text-sm">${item.description}</td>
                            <td class="py-4 px-4">
                                <div class="flex justify-end gap-2">
                                    <button type="button" class="p-2 hover:bg-secondary rounded-md transition-colors editBtn" title="Edit">
                                        <i data-lucide="edit" class="h-4 w-4 text-foreground"></i>
                                    </button>
                                    <form method="post" action="${pageContext.request.contextPath}/counselor/content/delete" data-title="${fn:escapeXml(item.title)}">
                                        <input type="hidden" name="id" value="${item.id}" />
                                        <button type="submit" class="p-2 hover:bg-destructive/10 rounded-md transition-colors" title="Delete">
                                            <i data-lucide="trash-2" class="h-4 w-4 text-destructive"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Overlay -->
<div id="modalOverlay" class="hidden fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity"></div>

<!-- Modal -->
<div id="contentModal" class="hidden fixed inset-0 z-50 overflow-y-auto">
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="bg-card rounded-lg shadow-xl w-full max-w-2xl transform transition-all">
            <!-- Modal Header -->
            <div class="flex items-center justify-between p-6 border-b border-border">
                <h2 id="modalTitle" class="text-xl font-semibold text-foreground">Add New Learning Content</h2>
                <button id="closeModal" class="text-muted-foreground hover:text-foreground transition-colors">
                    <i data-lucide="x" class="h-5 w-5"></i>
                </button>
            </div>
            
            <!-- Modal Body -->
            <form action="/counselor/content/create" method="POST" class="p-6 space-y-5" id="contentForm">
                <!-- Title -->
                <div>
                    <label for="title" class="block text-sm font-medium text-foreground mb-1.5">Title</label>
                    <input 
                        type="text" 
                        id="title" 
                        name="title" 
                        placeholder="Content title"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground"
                        required
                    />
                </div>
                <input type="hidden" id="editingId" name="editingId" value="" />
                
                <!-- Content Type -->
                <div>
                    <label for="contentType" class="block text-sm font-medium text-foreground mb-1.5">Content Type</label>
                    <select 
                        id="contentType" 
                        name="contentType"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground"
                        required
                    >
                        <option value="Article">Article</option>
                        <option value="Video">Video</option>
                    </select>
                </div>
                
                <!-- Description -->
                <div>
                    <label for="description" class="block text-sm font-medium text-foreground mb-1.5">Description</label>
                    <textarea 
                        id="description" 
                        name="description" 
                        rows="3"
                        placeholder="Brief description"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground resize-none"
                        required
                    ></textarea>
                </div>
                
                <!-- Content -->
                <div>
                    <label for="content" class="block text-sm font-medium text-foreground mb-1.5">Content</label>
                    <textarea 
                        id="content" 
                        name="content" 
                        rows="6"
                        placeholder="Main content or URL"
                        class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-ring bg-background text-foreground placeholder:text-muted-foreground resize-none"
                        required
                    ></textarea>
                </div>
                
                <!-- Modal Footer -->
                <div class="flex justify-end gap-3 pt-4">
                    <button 
                        type="button" 
                        id="cancelBtn"
                        class="px-4 py-2 border border-border rounded-md text-foreground hover:bg-secondary transition-colors font-medium"
                    >
                        Cancel
                    </button>
                    <button 
                        type="submit"
                        class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:opacity-90 transition-opacity font-medium shadow-sm"
                    >
                        Create Content
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Initialize Lucide icons when page loads
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    
    // Modal functionality
    const modal = document.getElementById('contentModal');
    const modalOverlay = document.getElementById('modalOverlay');
    const addContentBtn = document.getElementById('addContentBtn');
    const closeModalBtn = document.getElementById('closeModal');
    const cancelBtn = document.getElementById('cancelBtn');
    
    function openModal() {
        modal.classList.remove('hidden');
        modalOverlay.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }
    
    function closeModal() {
        modal.classList.add('hidden');
        modalOverlay.classList.add('hidden');
        document.body.style.overflow = 'auto';
    }
    
    addContentBtn.addEventListener('click', openModal);
    closeModalBtn.addEventListener('click', closeModal);
    cancelBtn.addEventListener('click', closeModal);
    modalOverlay.addEventListener('click', closeModal);
    
    // Close modal on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
            closeModal();
        }
    });

    // Edit handling: populate modal and submit to server for persistence
    (function() {
        const tableBody = document.querySelector('table tbody');
        const form = document.getElementById('contentForm');
        const editingId = document.getElementById('editingId');
        const titleInput = document.getElementById('title');
        const typeInput = document.getElementById('contentType');
        const descInput = document.getElementById('description');
        const contentInput = document.getElementById('content');
        const submitBtn = form.querySelector('button[type="submit"]');

        // when clicking Add New Content, ensure form is in create mode
        const modalTitle = document.getElementById('modalTitle');
        addContentBtn.addEventListener('click', () => {
            editingId.value = '';
            form.reset();
            if (submitBtn) submitBtn.textContent = 'Create Content';
            if (modalTitle) modalTitle.textContent = 'Add New Learning Content';
        });

        // delegate edit button clicks
        tableBody.addEventListener('click', function(e) {
            const editBtn = e.target.closest('.editBtn');
            if (!editBtn) return;
            const row = editBtn.closest('tr');
            const tds = row.querySelectorAll('td');
            const id = row.getAttribute('data-id');
            const title = (tds[0].querySelector('div > span') || { textContent: '' }).textContent.trim();
            const desc = tds[0].querySelector('p') ? tds[0].querySelector('p').textContent.trim() : (tds[2] ? tds[2].textContent.trim() : '');
            const typeCell = tds[1] ? tds[1].querySelector('span') : null;
            const type = typeCell ? typeCell.textContent.trim() : 'Article';

            editingId.value = id;
            titleInput.value = title;
            descInput.value = desc;
            typeInput.value = type;
            if (submitBtn) submitBtn.textContent = 'Update Content';
            if (modalTitle) modalTitle.textContent = 'Update Learning Content';
            openModal();
        });

        // attach confirmation to delete forms (safer than inline onsubmit)
        document.querySelectorAll('form[action$="/counselor/content/delete"]').forEach(function(f) {
            f.addEventListener('submit', function(evt) {
                const t = f.dataset.title || 'this item';
                if (!confirm('Delete "' + t + '"?')) {
                    evt.preventDefault();
                }
            });
        });
    })();
</script>

<jsp:include page="../common/footer.jsp" />