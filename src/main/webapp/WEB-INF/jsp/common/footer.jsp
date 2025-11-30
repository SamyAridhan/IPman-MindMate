<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

</main>

<footer class="bg-white/80 backdrop-blur-md border-t border-border mt-12">
    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <p class="text-center text-sm text-muted-foreground">&copy; 2025 MindMate Project. All rights reserved.</p>
    </div>
    
    
</footer>

<script>
    // Ensure Lucide icons are processed
    lucide.createIcons();

    // ============================================
    // CHATBOT STATE MANAGEMENT WITH PERSISTENCE
    // ============================================

    // Storage keys
    const STORAGE_KEYS = {
        MESSAGES: 'mindmate_chat_messages',
        IS_OPEN: 'mindmate_chat_is_open',
        LAST_INTERACTION: 'mindmate_chat_last_interaction'
    };

    // State variables
    let isChatOpen = false;
    let isLoading = false;
    let currentMessages = [];

    // DOM Elements
    const chatButton = document.getElementById('chat-open-button');
    const chatWindow = document.getElementById('chat-window');
    const messagesContainer = document.getElementById('messages-container');
    const inputField = document.getElementById('chat-input');
    const sendButton = document.getElementById('chat-send-button');
    const typingIndicator = document.getElementById('typing-indicator');

    // Only initialize if chatbot elements exist (student view)
    if (chatButton && chatWindow) {
        initializeChatbot();
    }

    // ============================================
    // INITIALIZATION
    // ============================================

    function initializeChatbot() {
        // Load saved state from sessionStorage
        loadChatState();
        
        // Restore chat window state
        const savedIsOpen = sessionStorage.getItem(STORAGE_KEYS.IS_OPEN);
        if (savedIsOpen === 'true') {
            toggleChatWindow(true);
        } else {
            toggleChatWindow(false);
        }

        // If no messages exist, add welcome message
        if (currentMessages.length === 0) {
            currentMessages = [{
                role: 'assistant',
                content: "Hello! I'm here to support you. How are you feeling today?",
                timestamp: new Date().toISOString()
            }];
            saveChatState();
        }

        renderMessages();

        // Add Enter key listener
        if (inputField) {
            inputField.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleSendMessage();
                }
            });
        }

        // Save state before page unload
        window.addEventListener('beforeunload', saveChatState);
    }

    // ============================================
    // STATE PERSISTENCE
    // ============================================

    function loadChatState() {
        try {
            const savedMessages = sessionStorage.getItem(STORAGE_KEYS.MESSAGES);
            if (savedMessages) {
                currentMessages = JSON.parse(savedMessages);
            }
        } catch (error) {
            console.error('Error loading chat state:', error);
            currentMessages = [];
        }
    }

    function saveChatState() {
        try {
            sessionStorage.setItem(STORAGE_KEYS.MESSAGES, JSON.stringify(currentMessages));
            sessionStorage.setItem(STORAGE_KEYS.IS_OPEN, isChatOpen.toString());
            sessionStorage.setItem(STORAGE_KEYS.LAST_INTERACTION, new Date().toISOString());
        } catch (error) {
            console.error('Error saving chat state:', error);
        }
    }

    function clearChatState() {
        sessionStorage.removeItem(STORAGE_KEYS.MESSAGES);
        sessionStorage.removeItem(STORAGE_KEYS.IS_OPEN);
        sessionStorage.removeItem(STORAGE_KEYS.LAST_INTERACTION);
        currentMessages = [{
            role: 'assistant',
            content: "Hello! I'm here to support you. How are you feeling today?",
            timestamp: new Date().toISOString()
        }];
        renderMessages();
    }

    // ============================================
    // CHAT WINDOW TOGGLE
    // ============================================

    function toggleChatWindow(open) {
        if (!chatWindow || !chatButton) return;
        
        isChatOpen = open;
        
        if (isChatOpen) {
            chatWindow.classList.remove('hidden');
            chatButton.classList.add('hidden');
            renderMessages();
            scrollToBottom();
            if (inputField) inputField.focus();
        } else {
            chatWindow.classList.add('hidden');
            chatButton.classList.remove('hidden');
        }
        
        saveChatState();
    }

    // ============================================
    // MESSAGE RENDERING
    // ============================================

    function renderMessages() {
        if (!messagesContainer) return;
        
        messagesContainer.innerHTML = '';
        
        currentMessages.forEach(msg => {
            const messageElement = createMessageElement(msg);
            messagesContainer.appendChild(messageElement);
        });
        
        scrollToBottom();
    }

    function createMessageElement(message) {
        const isUser = message.role === 'user';
        const messageDiv = document.createElement('div');
        messageDiv.className = `flex items-start gap-2 ${isUser ? 'flex-row-reverse' : 'flex-row'}`;
        
        // Avatar
        const avatar = document.createElement('div');
        if (isUser) {
            avatar.className = 'w-8 h-8 rounded-full bg-primary flex items-center justify-center text-primary-foreground font-semibold text-sm shrink-0';
            avatar.textContent = 'You';
        } else {
            avatar.className = 'w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30 shrink-0';
            avatar.innerHTML = '<i data-lucide="bot" class="h-4 w-4 text-primary"></i>';
        }
        
        // Message bubble
        const bubble = document.createElement('div');
        bubble.className = isUser 
            ? 'bg-primary text-primary-foreground rounded-2xl rounded-tr-sm px-4 py-2.5 max-w-[75%] shadow-sm'
            : 'bg-secondary text-foreground rounded-2xl rounded-tl-sm px-4 py-2.5 max-w-[75%] shadow-sm border border-border/50';
        
        const content = document.createElement('p');
        content.className = 'text-sm leading-relaxed whitespace-pre-wrap break-words';
        content.textContent = message.content;
        
        bubble.appendChild(content);
        
        // Timestamp (optional)
        if (message.timestamp) {
            const time = document.createElement('span');
            time.className = `text-[10px] mt-1 block ${isUser ? 'text-primary-foreground/70' : 'text-muted-foreground'}`;
            time.textContent = formatTime(message.timestamp);
            bubble.appendChild(time);
        }
        
        messageDiv.appendChild(avatar);
        messageDiv.appendChild(bubble);
        
        // Re-initialize Lucide icons for the new elements
        setTimeout(() => lucide.createIcons(), 0);
        
        return messageDiv;
    }

    function formatTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
    }

    function scrollToBottom() {
        if (messagesContainer) {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
    }

    // ============================================
    // MESSAGE HANDLING
    // ============================================

    function handleSendMessage() {
        if (!inputField) return;
        
        const userMessage = inputField.value.trim();
        if (!userMessage || isLoading) return;

        // Add user message
        currentMessages.push({
            role: 'user',
            content: userMessage,
            timestamp: new Date().toISOString()
        });
        
        inputField.value = '';
        renderMessages();
        saveChatState();

        // Show typing indicator
        isLoading = true;
        if (typingIndicator) typingIndicator.classList.remove('hidden');
        if (sendButton) sendButton.disabled = true;
        if (inputField) inputField.disabled = true;
        scrollToBottom();

        // Simulate AI response
        setTimeout(() => {
            const aiResponse = generateAIResponse(userMessage);
            
            currentMessages.push({
                role: 'assistant',
                content: aiResponse,
                timestamp: new Date().toISOString()
            });

            // Hide typing indicator
            isLoading = false;
            if (typingIndicator) typingIndicator.classList.add('hidden');
            if (sendButton) sendButton.disabled = false;
            if (inputField) inputField.disabled = false;
            
            renderMessages();
            saveChatState();
            
            if (inputField) inputField.focus();
        }, 1200);
    }

    function generateAIResponse(userMessage) {
        const lowerMessage = userMessage.toLowerCase();
        
        // Context-aware responses
        if (lowerMessage.includes('anxious') || lowerMessage.includes('anxiety') || lowerMessage.includes('worried')) {
            return "I understand you're feeling anxious. It's completely normal to feel this way sometimes. Have you tried any relaxation techniques like deep breathing or mindfulness? I'm here to help you through this.";
        }
        
        if (lowerMessage.includes('sad') || lowerMessage.includes('depressed') || lowerMessage.includes('down')) {
            return "I'm sorry you're feeling this way. Your feelings are valid, and it's important to acknowledge them. Would you like to talk about what's been troubling you? Sometimes sharing can help lighten the burden.";
        }
        
        if (lowerMessage.includes('stress') || lowerMessage.includes('stressed') || lowerMessage.includes('overwhelmed')) {
            return "Stress can be really challenging. Remember that it's okay to take breaks and prioritize self-care. Have you considered speaking with one of our counselors? They can provide you with personalized coping strategies.";
        }
        
        if (lowerMessage.includes('sleep') || lowerMessage.includes('insomnia') || lowerMessage.includes('tired')) {
            return "Sleep issues can significantly impact your well-being. Establishing a consistent bedtime routine and limiting screen time before bed can help. Would you like some specific tips for improving your sleep hygiene?";
        }
        
        if (lowerMessage.includes('help') || lowerMessage.includes('counselor') || lowerMessage.includes('appointment')) {
            return "I'm glad you're reaching out for help! You can easily book an appointment with one of our professional counselors. Would you like me to guide you through the booking process?";
        }
        
        if (lowerMessage.includes('thank')) {
            return "You're very welcome! I'm always here to support you. Remember, seeking help is a sign of strength. Is there anything else I can help you with today?";
        }
        
        // Default responses
        const defaultResponses = [
            "I'm here to listen and support you. Can you tell me more about what's on your mind?",
            "Thank you for sharing. Remember that you're not alone in this journey. How can I best support you right now?",
            "It's important to take care of your mental health. Would you like to explore some resources or speak with a counselor?",
            "I understand this is difficult. Have you considered what might help you feel better in this moment?",
            "Your well-being matters. Let's work through this together. What would be most helpful for you right now?"
        ];
        
        return defaultResponses[Math.floor(Math.random() * defaultResponses.length)];
    }
    
</script>
</html>