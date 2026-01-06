<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<!-- TinyMCE CDN -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/6.8.2/tinymce.min.js" referrerpolicy="origin"></script>

<div class="space-y-6">
<div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
<div>
<h1 class="text-3xl font-bold text-foreground">Content Management</h1>
<p class="text-muted-foreground mt-1">Create and manage educational modules for students</p>
</div>
<button id="addContentBtn" class="bg-primary text-primary-foreground px-4 py-2 rounded-xl hover:opacity-90 transition-all inline-flex items-center gap-2 font-bold shadow-lg shadow-primary/20">
<i data-lucide="plus" class="h-4 w-4"></i>
Add New Content
</button>
</div>

<!-- Table Section -->
<div class="bg-card p-6 rounded-2xl shadow-sm border border-border">
    <h2 class="text-xl font-semibold mb-4 text-foreground">All Learning Content</h2>
    
    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-border text-muted-foreground">
                    <th class="text-left py-3 px-4 font-semibold uppercase text-xs tracking-wider">Title & Summary</th>
                    <th class="text-left py-3 px-4 font-semibold uppercase text-xs tracking-wider hidden sm:table-cell">Type</th>
                    <th class="text-left py-3 px-4 font-semibold uppercase text-xs tracking-wider hidden md:table-cell">Points</th>
                    <th class="text-right py-3 px-4 font-semibold uppercase text-xs tracking-wider">Actions</th>
                </tr>
            </thead>
            <tbody id="contentTableBody">
                <c:forEach var="item" items="${contents}">
                    <tr data-id="${item.id}" 
                        data-points="${item.pointsValue}" 
                        data-type="${item.contentType}"
                        data-desc="${fn:escapeXml(item.description)}"
                        data-body="${fn:escapeXml(item.contentBody)}" 
                        class="border-b border-border hover:bg-secondary/30 transition-colors">
                        <td class="py-4 px-4">
                            <div class="flex items-center gap-3">
                                <div class="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary shrink-0">
                                    <c:choose>
                                        <c:when test="${item.contentType == 'Video'}">
                                            <i data-lucide="play" class="h-5 w-5"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i data-lucide="file-text" class="h-5 w-5"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="min-w-0">
                                    <span class="font-bold block text-foreground truncate">${item.title}</span>
                                    <span class="text-xs text-muted-foreground line-clamp-1">${item.description}</span>
                                </div>
                            </div>
                        </td>
                        <td class="py-4 px-4 hidden sm:table-cell">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase tracking-tighter bg-secondary text-secondary-foreground border border-border/50">
                                ${item.contentType}
                            </span>
                        </td>
                        <td class="py-4 px-4 hidden md:table-cell font-bold text-primary">
                            ${item.pointsValue} Pts
                        </td>
                        <td class="py-4 px-4 text-right">
                            <div class="flex justify-end gap-1">
                                <button type="button" class="p-2 hover:bg-secondary rounded-md transition-colors editBtn text-muted-foreground hover:text-foreground" title="Edit">
                                    <i data-lucide="edit-3" class="h-4 w-4"></i>
                                </button>
                                <form method="POST" action="${pageContext.request.contextPath}/counselor/content/delete" class="inline" onsubmit="return confirm('Delete this module?');">
                                    <input type="hidden" name="id" value="${item.id}" />
                                    <button type="submit" class="p-2 hover:bg-destructive/10 rounded-md transition-colors text-destructive" title="Delete">
                                        <i data-lucide="trash-2" class="h-4 w-4"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty contents}">
                    <tr>
                        <td colspan="4" class="py-20 text-center text-muted-foreground italic">No modules found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>


</div>

<!-- Modal Overlay -->

<div id="modalOverlay" class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-40 transition-opacity"></div>

<!-- Modal -->

<div id="contentModal" class="hidden fixed inset-0 z-50 overflow-y-auto">
<div class="flex min-h-screen items-center justify-center p-4">
<div class="bg-card rounded-2xl shadow-2xl w-full max-w-3xl transform transition-all border border-border overflow-hidden">
<!-- Modal Header -->
<div class="flex items-center justify-between p-6 border-b border-border bg-gradient-to-r from-card to-secondary/20">
<div>
<h2 id="modalTitle" class="text-xl font-black text-foreground uppercase tracking-tight">Add New Module</h2>
<p class="text-xs text-muted-foreground font-medium uppercase tracking-widest mt-0.5">Publish resources for your students</p>
</div>
<button id="closeModal" class="p-2 rounded-xl hover:bg-secondary transition-colors">
<i data-lucide="x" class="h-5 w-5"></i>
</button>
</div>

        <!-- Modal Body -->
        <form action="${pageContext.request.contextPath}/counselor/content/create" method="POST" class="p-6 space-y-6" id="contentForm">
            <input type="hidden" id="editingId" name="editingId" value="" />
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="md:col-span-2">
                    <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-2">Module Title</label>
                    <div class="relative">
                        <i data-lucide="book" class="absolute left-3 top-3 h-4 w-4 text-muted-foreground"></i>
                        <input type="text" id="title" name="title" class="w-full pl-10 pr-4 py-2.5 border border-input rounded-xl bg-background font-bold focus:ring-2 focus:ring-primary/20 outline-none" required />
                    </div>
                </div>
                <div class="md:col-span-1">
                    <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-2">Points</label>
                    <div class="relative">
                        <i data-lucide="sparkles" class="absolute left-3 top-3 h-4 w-4 text-yellow-500"></i>
                        <input type="number" id="points" name="points" class="w-full pl-10 pr-4 py-2.5 border border-input rounded-xl bg-background font-bold focus:ring-2 focus:ring-primary/20 outline-none" required />
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-3">Content Type</label>
                <div class="flex gap-4" id="contentTypeContainer">
                    <label class="flex-1 cursor-pointer" id="labelArticle">
                        <input type="radio" name="contentType" value="Article" checked class="hidden peer" id="typeArticle">
                        <div class="p-3 border-2 border-border rounded-xl flex flex-col items-center gap-1 peer-checked:border-primary peer-checked:bg-primary/5 peer-disabled:opacity-50 peer-disabled:cursor-not-allowed transition-all">
                            <i data-lucide="file-text" class="h-5 w-5"></i>
                            <span class="font-bold text-xs uppercase">Article</span>
                        </div>
                    </label>
                    <label class="flex-1 cursor-pointer" id="labelVideo">
                        <input type="radio" name="contentType" value="Video" class="hidden peer" id="typeVideo">
                        <div class="p-3 border-2 border-border rounded-xl flex flex-col items-center gap-1 peer-checked:border-primary peer-checked:bg-primary/5 peer-disabled:opacity-50 peer-disabled:cursor-not-allowed transition-all">
                            <i data-lucide="play-circle" class="h-5 w-5"></i>
                            <span class="font-bold text-xs uppercase">Video</span>
                        </div>
                    </label>
                </div>
                <p id="lockMessage" class="hidden text-xs text-amber-600 mt-2 flex items-center gap-1">
                    <i data-lucide="lock" class="h-3 w-3"></i>
                    <span>Content type is locked and cannot be changed</span>
                </p>
            </div>

            <div>
                <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-2">Short Summary</label>
                <textarea id="description" name="description" rows="2" class="w-full px-4 py-3 border border-input rounded-xl bg-background resize-none text-sm font-medium focus:ring-2 focus:ring-primary/20 outline-none" required></textarea>
            </div>
            
            <!-- Dynamic Input Group -->
            <div id="articleInputGroup">
                <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-2">Article Content</label>
                <textarea id="articleEditor" name="articleEditor"></textarea>
            </div>

            <div id="videoInputGroup" class="hidden">
                <label class="block text-xs font-black text-muted-foreground uppercase tracking-widest mb-2">Video URL (YouTube)</label>
                <div class="relative">
                    <i data-lucide="link" class="absolute left-4 top-3.5 h-4 w-4 text-muted-foreground"></i>
                    <input type="url" id="videoUrl" class="w-full pl-12 pr-4 py-3 border border-input rounded-xl bg-background font-medium text-sm focus:ring-2 focus:ring-primary/20 outline-none" placeholder="https://www.youtube.com/watch?v=..." />
                </div>
            </div>
            
            <!-- Hidden input to hold the final merged content -->
            <input type="hidden" name="content" id="mergedContent" />

            <div class="flex items-center justify-end gap-3 pt-6 border-t border-border">
                <button type="button" id="cancelBtn" class="px-6 py-2.5 rounded-xl font-bold text-sm text-foreground hover:bg-secondary transition-all">Discard</button>
                <button type="submit" id="submitBtn" class="px-8 py-2.5 bg-primary text-primary-foreground rounded-xl font-black uppercase tracking-widest text-xs shadow-lg shadow-primary/20 hover:opacity-90 transition-all">Publish Module</button>
            </div>
        </form>
    </div>
</div>


</div>

<script>
// Initialize TinyMCE
tinymce.init({
selector: '#articleEditor',
height: 300,
menubar: false,
plugins: 'lists link wordcount table autoresize',
toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | bullist numlist | link | table',
branding: false,
promotion: false,
skin: 'oxide',
content_style: 'body { font-family:Inter,sans-serif; font-size:14px; color: #374151; }'
});

const modal = document.getElementById('contentModal');
const modalOverlay = document.getElementById('modalOverlay');
const addBtn = document.getElementById('addContentBtn');
const closeBtn = document.getElementById('closeModal');
const cancelBtn = document.getElementById('cancelBtn');
const form = document.getElementById('contentForm');
const articleGroup = document.getElementById('articleInputGroup');
const videoGroup = document.getElementById('videoInputGroup');
const videoUrlInput = document.getElementById('videoUrl');
const typeRadios = document.querySelectorAll('input[name="contentType"]');
const mergedContent = document.getElementById('mergedContent');
let isEditMode = false; // Track if we're in edit mode

function toggleInputs(type) {
if (type === 'Video') {
articleGroup.classList.add('hidden');
videoGroup.classList.remove('hidden');
videoUrlInput.required = true;
} else {
articleGroup.classList.remove('hidden');
videoGroup.classList.add('hidden');
videoUrlInput.required = false;
}
}

typeRadios.forEach(radio => {
radio.addEventListener('change', (e) => {
    // Prevent changing when in edit mode
    if (isEditMode) {
        e.preventDefault();
        return false;
    }
    toggleInputs(e.target.value);
});
});

function openModal() {
modal.classList.remove('hidden');
modalOverlay.classList.remove('hidden');
document.body.style.overflow = 'hidden';
if (typeof lucide !== 'undefined') lucide.createIcons();
}

function closeModal() {
modal.classList.add('hidden');
modalOverlay.classList.add('hidden');
document.body.style.overflow = 'auto';
}

addBtn.addEventListener('click', () => {
form.reset();
isEditMode = false; // Not in edit mode
document.getElementById('editingId').value = '';
document.getElementById('modalTitle').textContent = 'Add New Module';
document.getElementById('submitBtn').textContent = 'Publish Module';
if (tinymce.get('articleEditor')) tinymce.get('articleEditor').setContent('');
document.getElementById('typeArticle').checked = true;
toggleInputs('Article');
// Enable content type selection for new content
document.getElementById('typeArticle').disabled = false;
document.getElementById('typeVideo').disabled = false;
document.getElementById('labelArticle').style.pointerEvents = 'auto';
document.getElementById('labelVideo').style.pointerEvents = 'auto';
document.getElementById('lockMessage').classList.add('hidden');
openModal();
});

closeBtn.addEventListener('click', closeModal);
cancelBtn.addEventListener('click', closeModal);

document.getElementById('contentTableBody').addEventListener('click', (e) => {
const btn = e.target.closest('.editBtn');
if (!btn) return;

const row = btn.closest('tr');
const type = row.getAttribute('data-type');
const body = row.getAttribute('data-body');
isEditMode = true; // Set edit mode to true

document.getElementById('editingId').value = row.getAttribute('data-id');
document.getElementById('title').value = row.querySelector('.font-bold').textContent;
document.getElementById('points').value = row.getAttribute('data-points');
document.getElementById('description').value = row.getAttribute('data-desc');

// Clear both inputs first
videoUrlInput.value = '';
if(tinymce.get('articleEditor')) tinymce.get('articleEditor').setContent('');

// Set the correct radio button based on content type from DB
if (type === 'Video') {
    document.getElementById('typeVideo').checked = true;
    videoUrlInput.value = body;
} else {
    document.getElementById('typeArticle').checked = true;
    if(tinymce.get('articleEditor')) tinymce.get('articleEditor').setContent(body);
}

// Toggle inputs to show correct editor AFTER setting radio and content
toggleInputs(type);

// Lock content type when editing
// Lock content type when editing (after setting the correct type)
document.getElementById('typeArticle').disabled = true;
document.getElementById('typeVideo').disabled = true;
document.getElementById('labelArticle').style.pointerEvents = 'none';
document.getElementById('labelVideo').style.pointerEvents = 'none';
document.getElementById('lockMessage').classList.remove('hidden');

document.getElementById('modalTitle').textContent = 'Update Module';
document.getElementById('submitBtn').textContent = 'Update Module';
openModal();
});

form.addEventListener('submit', (e) => {
e.preventDefault();

// Re-enable radio buttons before form submission so their values are sent
document.getElementById('typeArticle').disabled = false;
document.getElementById('typeVideo').disabled = false;

const type = document.querySelector('input[name="contentType"]:checked').value;
if (type === 'Video') {
mergedContent.value = videoUrlInput.value;
} else {
if (tinymce.get('articleEditor')) {
mergedContent.value = tinymce.get('articleEditor').getContent();
}
}
form.submit();
});

if (typeof lucide !== 'undefined') lucide.createIcons();
</script>

<style>
.tox-tinymce { border-radius: 0.75rem !important; border-color: hsl(var(--border)) !important; }
.animate-in { animation: fadeIn 0.2s ease-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
</style>

<jsp:include page="../common/footer.jsp" />