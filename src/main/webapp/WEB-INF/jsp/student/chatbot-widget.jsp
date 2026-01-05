<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="ai-chat-widget" class="z-50">
    
    <%-- 1. Floating Chat Button --%>
    <button
        id="chat-open-button"
        onclick="toggleChatWindow(true)"
        class="fixed bottom-6 right-6 z-50 h-16 w-16 rounded-full shadow-xl bg-primary text-primary-foreground hover:scale-110 transition-all duration-300 group"
    >
        <i data-lucide="message-circle" class="h-7 w-7 mx-auto group-hover:scale-110 transition-transform"></i>
        <span class="absolute -top-1 -right-1 w-5 h-5 bg-green-500 rounded-full border-2 border-white animate-pulse"></span>
    </button>

    <%-- 2. Chat Window --%>
    <div
        id="chat-window"
        class="fixed bottom-6 right-6 z-50 w-[380px] h-[600px] shadow-2xl flex flex-col bg-card rounded-2xl border border-border hidden overflow-hidden"
    >
        <%-- INTERNAL SIDEBAR (Glides over the messages) --%>
        <div id="chat-sidebar" class="absolute inset-y-0 left-0 w-full bg-card z-[60] transform -translate-x-full transition-transform duration-300 flex flex-col border-r border-border">
            <div class="p-4 border-b border-border flex justify-between items-center bg-muted/30">
                <h2 class="font-bold text-xs text-foreground uppercase tracking-wider">Chat History</h2>
                <button onclick="toggleSidebar(false)" class="p-1.5 hover:bg-secondary rounded-lg transition-colors">
                    <i data-lucide="chevron-left" class="h-5 w-5"></i>
                </button>
            </div>
            
            <div class="p-4">
                <button onclick="startNewChat()" class="w-full flex items-center justify-center gap-2 py-2.5 bg-primary text-primary-foreground rounded-xl hover:bg-primary/90 transition-all text-sm font-semibold shadow-sm">
                    <i data-lucide="plus" class="h-4 w-4"></i>
                    New Chat
                </button>
            </div>

            <div id="history-list" class="flex-1 space-y-1 overflow-y-auto px-4 pb-4 custom-scrollbar">
                <%-- History items load here --%>
            </div>
        </div>

        <%-- 3. Header --%>
        <div class="p-4 border-b border-border bg-gradient-to-r from-primary/10 to-primary/5">
            <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-3">
                    <button onclick="toggleSidebar(true)" class="p-1.5 rounded-lg text-muted-foreground hover:bg-primary/10 hover:text-primary transition-colors">
                        <i data-lucide="menu" class="h-5 w-5"></i>
                    </button>
                    <div class="w-9 h-9 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30">
                        <i data-lucide="bot" class="h-5 w-5 text-primary"></i>
                    </div>
                    <div>
                        <h3 class="font-semibold text-sm text-foreground">MindMate Assistant</h3>
                        <p class="text-[10px] text-muted-foreground flex items-center gap-1">
                            <span class="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse"></span>
                            Online
                        </p>
                    </div>
                </div>
                <button onclick="toggleChatWindow(false)" class="p-1.5 text-muted-foreground hover:text-foreground">
                    <i data-lucide="x" class="h-5 w-5"></i>
                </button>
            </div>
        </div>

        <%-- 4. Messages Container --%>
        <div id="messages-container" class="flex-1 overflow-y-auto p-4 space-y-4 bg-background/50 custom-scrollbar">
            <%-- Messages render here --%>
        </div>

        <%-- 5. Typing Indicator --%>
        <div id="typing-indicator" class="px-4 pb-2 hidden">
            <div class="flex items-center gap-2 text-[11px] text-muted-foreground italic">
                <div class="flex gap-0.5">
                    <span class="w-1 h-1 bg-primary/60 rounded-full animate-bounce"></span>
                    <span class="w-1 h-1 bg-primary/60 rounded-full animate-bounce" style="animation-delay: 0.2s"></span>
                    <span class="w-1 h-1 bg-primary/60 rounded-full animate-bounce" style="animation-delay: 0.4s"></span>
                </div>
                MindMate is typing...
            </div>
        </div>

        <%-- 6. Input Area --%>
        <div class="p-4 bg-card border-t border-border">
            <form onsubmit="handleSendMessage(); return false;" class="flex gap-2">
                <input id="chat-input" type="text" placeholder="Tell me how you feel..." 
                       class="flex-1 h-10 bg-background border border-input rounded-xl px-4 py-2 text-sm focus:ring-1 focus:ring-primary outline-none transition-all">
                <button id="chat-send-button" type="submit" class="h-10 w-10 bg-primary text-primary-foreground rounded-xl flex items-center justify-center hover:opacity-90 transition-all">
                    <i data-lucide="send" class="h-4 w-4"></i>
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    lucide.createIcons();

    let isChatOpen = false;
    let isLoading = false;
    let currentMessages = [];

    const chatWindow = document.getElementById('chat-window');
    const chatButton = document.getElementById('chat-open-button');
    const messagesContainer = document.getElementById('messages-container');
    const inputField = document.getElementById('chat-input');
    const typingIndicator = document.getElementById('typing-indicator');

    // Initialize
    document.addEventListener('DOMContentLoaded', () => {
        loadCurrentHistory();
    });

    // ============================================
    // SIDEBAR & HISTORY LOGIC
    // ============================================

    function toggleSidebar(open) {
        const sidebar = document.getElementById('chat-sidebar');
        if (open) {
            sidebar.classList.remove('-translate-x-full');
            fetchSessions();
        } else {
            sidebar.classList.add('-translate-x-full');
        }
    }

    async function fetchSessions() {
        try {
            const response = await fetch('/api/chat/sessions');
            const sessions = await response.json();
            const list = document.getElementById('history-list');
            
            list.innerHTML = sessions.map(sid => `
                <button onclick="loadSession('${sid}')" class="w-full text-left p-3 rounded-xl hover:bg-primary/5 text-xs flex items-center gap-3 transition-all border border-transparent hover:border-border group">
                    <i data-lucide="message-square" class="h-4 w-4 text-muted-foreground group-hover:text-primary"></i>
                    <span class="truncate text-muted-foreground group-hover:text-foreground">${sid.replace('chat_', 'Conversation ')}</span>
                </button>
            `).join('');
            lucide.createIcons();
        } catch (e) { console.error("History fetch failed", e); }
    }

    async function loadSession(sessionId) {
        try {
            const response = await fetch('/api/chat/history/load?sessionId=' + sessionId);
            currentMessages = await response.json();
            renderMessages();
            toggleSidebar(false);
        } catch (e) { console.error("Session load failed", e); }
    }

    async function startNewChat() {
        try {
            await fetch('/api/chat/new', { method: 'POST' });
            currentMessages = [{
                role: 'assistant',
                content: "Hello! I've started a fresh conversation for you. How are you feeling right now?",
                timestamp: new Date().toISOString()
            }];
            renderMessages();
            toggleSidebar(false);
        } catch (e) { console.error("New chat failed", e); }
    }

    // ============================================
    // CORE CHAT ACTIONS
    // ============================================

    function toggleChatWindow(open) {
        isChatOpen = open;
        chatWindow.classList.toggle('hidden', !open);
        chatButton.classList.toggle('hidden', open);
        if (open) {
            scrollToBottom();
            inputField.focus();
        }
    }

    async function handleSendMessage() {
        const message = inputField.value.trim();
        if (!message || isLoading) return;

        // UI: Add user message
        const userMsg = { role: 'user', content: message, timestamp: new Date().toISOString() };
        currentMessages.push(userMsg);
        inputField.value = '';
        renderMessages();

        isLoading = true;
        typingIndicator.classList.remove('hidden');
        scrollToBottom();

        try {
            const response = await fetch('/api/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: message
            });
            
            const aiMsg = await response.json();
            console.log("Server Response:", aiMsg); // Check your browser console (F12)
            
            if (aiMsg && (aiMsg.content || aiMsg.text)) {
                currentMessages.push(aiMsg);
            } else {
                throw new Error("Empty content received");
            }
            renderMessages();
        } catch (error) {
            console.error('Send Error:', error);
        } finally {
            isLoading = false;
            typingIndicator.classList.add('hidden');
            scrollToBottom();
        }
    }

    async function loadCurrentHistory() {
        try {
            const response = await fetch('/api/chat/history/current');
            const history = await response.json();
            if (history && history.length > 0) {
                currentMessages = history;
            } else {
                currentMessages = [{
                    role: 'assistant',
                    content: "Hello! I'm MindMate. How are you feeling today?",
                    timestamp: new Date().toISOString()
                }];
            }
            renderMessages();
        } catch (e) { console.error("Load history error", e); }
    }

    function renderMessages() {
        messagesContainer.innerHTML = '';
        currentMessages.forEach(msg => {
            const isUser = msg.role === 'user';
            
            // FIX: Ensure we are grabbing the text correctly regardless of naming
            const textContent = msg.content || msg.text || ""; 
            
            const html = `
                <div class="flex items-start gap-2 ${isUser ? 'flex-row-reverse' : 'flex-row'}">
                    <div class="w-8 h-8 rounded-full ${isUser ? 'bg-primary' : 'bg-primary/20'} flex items-center justify-center shrink-0 border border-primary/10">
                        <i data-lucide="${isUser ? 'user' : 'bot'}" class="h-4 w-4 ${isUser ? 'text-primary-foreground' : 'text-primary'}"></i>
                    </div>
                    <div class="${isUser ? 'bg-primary text-primary-foreground rounded-tr-none' : 'bg-secondary text-foreground rounded-tl-none shadow-sm'} rounded-2xl px-4 py-2.5 max-w-[80%]">
                        <p class="text-sm leading-relaxed whitespace-pre-wrap">${textContent}</p>
                    </div>
                </div>
            `;
            messagesContainer.insertAdjacentHTML('beforeend', html);
        });
        lucide.createIcons();
        scrollToBottom();
    }

    function scrollToBottom() {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
</script>

<style>
    .custom-scrollbar::-webkit-scrollbar { width: 4px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }
</style>