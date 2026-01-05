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
        <div class="p-4 border-b border-border bg-gradient-to-r from-primary/10 to-primary/5 relative z-10">
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
        <div id="messages-container" class="flex-1 overflow-y-auto p-4 bg-background custom-scrollbar relative z-0 flex flex-col">
            <%-- Messages render here --%>
        </div>

        <%-- 5. Typing Indicator --%>
        <div id="typing-indicator" class="px-4 pb-2 hidden relative z-10">
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
        <div class="p-4 bg-card border-t border-border relative z-10">
            <form onsubmit="handleSendMessage(); return false;" class="flex gap-2">
                <input id="chat-input" type="text" placeholder="Tell me how you feel..." 
                       class="flex-1 h-10 bg-background border border-input rounded-xl px-4 py-2 text-sm focus:ring-1 focus:ring-primary outline-none transition-all text-foreground" autocomplete="off">
                <button id="chat-send-button" type="submit" class="h-10 w-10 bg-primary text-primary-foreground rounded-xl flex items-center justify-center hover:opacity-90 transition-all">
                    <i data-lucide="send" class="h-4 w-4"></i>
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    // Ensure Lucide icons are initialized
    lucide.createIcons();

    let isChatOpen = false;
    let isLoading = false;
    let currentMessages = [];

    const chatWindow = document.getElementById('chat-window');
    const chatButton = document.getElementById('chat-open-button');
    const messagesContainer = document.getElementById('messages-container');
    const inputField = document.getElementById('chat-input');
    const typingIndicator = document.getElementById('typing-indicator');

    // Initialize on page load
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
            console.log('Sessions fetched:', sessions);
            const list = document.getElementById('history-list');
            
            list.innerHTML = sessions.map(session => {
                // session should be an object with sessionId and title
                const sessionId = session.sessionId || session;
                const title = session.title || 'Chat';
                
                console.log('Rendering session:', sessionId, title);
                
                return `
                    <button onclick="loadSession('${sessionId}')" class="w-full text-left p-3 rounded-xl hover:bg-primary/5 text-xs flex items-center gap-3 transition-all border border-transparent hover:border-border group">
                        <i data-lucide="message-square" class="h-4 w-4 text-muted-foreground group-hover:text-primary"></i>
                        <span class="truncate text-muted-foreground group-hover:text-foreground font-medium">${title}</span>
                    </button>
                `;
            }).join('');
            lucide.createIcons();
        } catch (e) { 
            console.error("History fetch failed", e); 
        }
    }

    async function loadSession(sessionId) {
        try {
            const response = await fetch('/api/chat/history/load?sessionId=' + sessionId);
            currentMessages = await response.json();
            renderMessages();
            toggleSidebar(false);
        } catch (e) { 
            console.error("Session load failed", e); 
        }
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
        } catch (e) { 
            console.error("New chat failed", e); 
        }
    }

    // ============================================
    // CORE CHAT ACTIONS
    // ============================================

    function toggleChatWindow(open) {
        isChatOpen = open;
        chatWindow.classList.toggle('hidden', !open);
        chatButton.classList.toggle('hidden', open);
        if (open) {
            setTimeout(() => {
                scrollToBottom();
                inputField.focus();
            }, 50);
        }
    }

    async function handleSendMessage() {
        const message = inputField.value.trim();
        if (!message || isLoading) return;

        // 1. Add User Message locally - store ONLY the plain message text
        const userMsg = { 
            role: 'user', 
            content: message,  // Plain text, NOT JSON
            timestamp: new Date().toISOString() 
        };
        currentMessages.push(userMsg);
        console.log('User message added:', userMsg);
        inputField.value = ''; 
        renderMessages();
        scrollToBottom();

        isLoading = true;
        typingIndicator.classList.remove('hidden');
        scrollToBottom();

        try {
            const response = await fetch('/api/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message })
            });
            
            if (!response.ok) throw new Error('Server error');

            const data = await response.json();
            console.log('Backend response:', data);
            
            // Extract the message data from the response
            if (data && data.content) {
                const aiMsg = {
                    role: data.role || 'assistant',
                    content: data.content,
                    timestamp: data.timestamp || new Date().toISOString()
                };
                currentMessages.push(aiMsg);
                console.log('AI message added:', aiMsg);
            } else {
                throw new Error("Empty response");
            }
        } catch (error) {
            console.error('Send Error:', error);
            currentMessages.push({
                role: 'assistant',
                content: "I'm having trouble connecting to my brain right now. Please try again later.",
                timestamp: new Date().toISOString()
            });
        } finally {
            isLoading = false;
            typingIndicator.classList.add('hidden');
            renderMessages(); 
            scrollToBottom();
        }
    

        isLoading = true;
        typingIndicator.classList.remove('hidden');
        scrollToBottom();

        try {
            const response = await fetch('/api/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message })
            });
            
            if (!response.ok) throw new Error('Server error');

            const data = await response.json();
            
            // Extract the message data from the response
            if (data && data.content) {
                const aiMsg = {
                    role: data.role || 'assistant',
                    content: data.content,
                    timestamp: data.timestamp || new Date().toISOString()
                };
                currentMessages.push(aiMsg);
                console.log('Message added:', aiMsg);
            } else {
                throw new Error("Empty response");
            }
        } catch (error) {
            console.error('Send Error:', error);
            currentMessages.push({
                role: 'assistant',
                content: "I'm having trouble connecting to my brain right now. Please try again later.",
                timestamp: new Date().toISOString()
            });
        } finally {
            isLoading = false;
            typingIndicator.classList.add('hidden');
            renderMessages(); 
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
        } catch (e) { 
            console.error("Load history error", e); 
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function renderMessages() {
        if (!messagesContainer) return;
        messagesContainer.innerHTML = '';

        currentMessages.forEach((msg) => {
            const isUser = msg.role === 'user';
            const textToDisplay = msg.content || "";

            // Container for the entire message (with alignment)
            const div = document.createElement('div');
            div.style.display = 'flex';
            div.style.marginBottom = '12px';
            div.style.justifyContent = isUser ? 'flex-end' : 'flex-start';

            // Wrapper for avatar + bubble
            const wrapper = document.createElement('div');
            wrapper.style.display = 'flex';
            wrapper.style.alignItems = 'flex-end';
            wrapper.style.gap = '8px';
            if (isUser) wrapper.style.flexDirection = 'row-reverse';

            // Avatar
            const avatar = document.createElement('div');
            avatar.style.width = '32px';
            avatar.style.height = '32px';
            avatar.style.borderRadius = '50%';
            avatar.style.display = 'flex';
            avatar.style.alignItems = 'center';
            avatar.style.justifyContent = 'center';
            avatar.style.flexShrink = '0';
            avatar.style.border = '1px solid rgba(0,0,0,0.1)';
            
            if (isUser) {
                avatar.style.backgroundColor = 'rgb(219, 112, 147)'; // primary pink
                avatar.innerHTML = '<i data-lucide="user" style="color: white; width: 16px; height: 16px;"></i>';
            } else {
                avatar.style.backgroundColor = 'rgba(219, 112, 147, 0.2)';
                avatar.innerHTML = '<i data-lucide="bot" style="color: rgb(219, 112, 147); width: 16px; height: 16px;"></i>';
            }

            // Message bubble
            const bubble = document.createElement('div');
            bubble.style.borderRadius = '16px';
            bubble.style.padding = '12px 16px';
            bubble.style.maxWidth = '280px';
            bubble.style.boxShadow = '0 1px 3px rgba(0,0,0,0.1)';
            
            if (isUser) {
                bubble.style.backgroundColor = 'rgb(219, 112, 147)'; // primary
                bubble.style.color = 'white';
            } else {
                bubble.style.backgroundColor = 'rgb(245, 245, 245)'; // secondary light
                bubble.style.color = 'rgb(64, 64, 64)';
            }

            const p = document.createElement('p');
            p.style.fontSize = '14px';
            p.style.lineHeight = '1.5';
            p.style.whiteSpace = 'pre-wrap';
            p.style.wordBreak = 'break-word';
            p.style.margin = '0';
            p.textContent = textToDisplay;

            bubble.appendChild(p);
            wrapper.appendChild(avatar);
            wrapper.appendChild(bubble);
            div.appendChild(wrapper);

            messagesContainer.appendChild(div);
        });

        setTimeout(() => lucide.createIcons(), 0);
        scrollToBottom();
    }

    function scrollToBottom() {
        if (messagesContainer) {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
    }
</script>

<style>
    .custom-scrollbar::-webkit-scrollbar { width: 4px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(0,0,0,0.2); }
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(4px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .animate-fadeIn {
        animation: fadeIn 0.3s ease-in-out;
    }
</style>