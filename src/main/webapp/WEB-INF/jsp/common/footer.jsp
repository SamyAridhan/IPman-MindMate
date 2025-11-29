</main>
<footer class="bg-white/80 backdrop-blur-md border-t border-border mt-12">
    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <p class="text-center text-sm text-muted-foreground">&copy; 2025 MindMate Project. All rights reserved.</p>
    </div>
    <jsp:include page="chatbot-widget.jsp" /> 
</footer>

<script>
    // Ensure Lucide icons are processed
    lucide.createIcons();

    // 1. STATE VARIABLES
    let isChatOpen = false;
    let isLoading = false;
    
    let currentMessages = [
        { role: 'assistant', content: "Hello! I'm here to support you. How are you feeling today?" }
    ];

    // DOM Elements
    // NOTE: These must be declared *before* any function that uses them is called (like toggleChatWindow(false) below)
    const chatButton = document.getElementById('chat-open-button');
    const chatWindow = document.getElementById('chat-window');
    const messagesContainer = document.getElementById('messages-container');
    const inputField = document.getElementById('chat-input');
    const sendButton = document.getElementById('chat-send-button');
    const messagesEndRef = document.getElementById('messages-end-ref');
    const loadingIndicator = document.getElementById('loading-indicator');

    // --- Core Functions ---

    /**
     * 2. Toggles the visibility of the chat window.
     */
    function toggleChatWindow(open) {
        // Safety check: only proceed if essential DOM elements exist
        if (!chatWindow || !chatButton) return; 
        
        isChatOpen = open;
        if (isChatOpen) {
            chatWindow.classList.remove('hidden');
            chatButton.classList.add('hidden');
            renderMessages(); // Render messages when opening
            scrollToBottom();
        } else {
            chatWindow.classList.add('hidden');
            chatButton.classList.remove('hidden');
        }
    }

    /**
     * Helper function to scroll to the bottom of the chat.
     */
    function scrollToBottom() {
        if (messagesEndRef) {
            messagesEndRef.scrollIntoView({ behavior: "smooth" });
        }
    }

    /**
     * 3. Renders all messages from the currentMessages array into the container.
     */
    function renderMessages() {
        if (!messagesContainer) return; // Safety check
        
        // Clear old content
        messagesContainer.innerHTML = '';
        
        currentMessages.forEach(msg => {
            const isUser = msg.role === 'user';
            const alignmentClass = isUser ? "justify-end" : "justify-start"; 
            const colorClass = isUser ? "bg-primary text-primary-foreground" : "bg-muted text-foreground";

            // 1. CREATE the outer div
            const messageDiv = document.createElement('div');
            messageDiv.className = `flex ${alignmentClass}`; 
            
            // 2. CREATE the inner content div
            const contentDiv = document.createElement('div');
            // 3. APPLY classes and text
            contentDiv.className = `rounded-lg px-4 py-2 max-w-[80%] ${colorClass}`;
            contentDiv.textContent = msg.content;
            
            // 4. APPEND
            messageDiv.appendChild(contentDiv);
            messagesContainer.appendChild(messageDiv);
        });

        // Re-append the loading indicator and scroll ref after messages
        if (loadingIndicator) messagesContainer.appendChild(loadingIndicator);
        if (messagesEndRef) messagesContainer.appendChild(messagesEndRef);
        
        scrollToBottom();
    }
    
    /**
     * 4. Handles sending the message (SIMULATION MODE).
     * NOTE: 'async' removed as fetch/await is commented out.
     */
    function handleSendMessage() { 
        if (!inputField) return; // Safety check
        
        const userMessage = inputField.value.trim();
        if (!userMessage || isLoading) return;

        // A. Add user message to state and UI
        currentMessages.push({ role: 'user', content: userMessage });
        inputField.value = '';
        renderMessages();

        // B. Show loading state
        isLoading = true;
        if (loadingIndicator) loadingIndicator.classList.remove('hidden');
        if (sendButton) sendButton.disabled = true;
        if (inputField) inputField.disabled = true;
        scrollToBottom();

        // --- SIMULATION START ---
        const responses = [
            "I understand you're going through a difficult time. Remember that seeking help is a sign of strength.",
            "It's important to take care of your mental health. Have you considered speaking with a counselor?",
            "Thank you for sharing. Would you like me to help you find some resources or schedule a session?",
            "I'm here to listen. Please know that you're not alone in this.",
        ];
        const aiResponseText = responses[Math.floor(Math.random() * responses.length)];

        // Simulate a network delay (1 second)
        setTimeout(() => {
            // E. Update state and UI with simulated AI message
            currentMessages.push({ role: 'assistant', content: aiResponseText });

            // F. Hide loading state and re-render
            isLoading = false;
            if (loadingIndicator) loadingIndicator.classList.add('hidden');
            if (sendButton) sendButton.disabled = false;
            if (inputField) inputField.disabled = false;
            renderMessages();

        }, 1000); // 1-second delay
        // --- SIMULATION END ---
    }
    
    // --- Event Listeners ---
    
    // Add Enter key functionality to the input field
    if (inputField) {
        inputField.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                handleSendMessage();
            }
        });
    }

    // Initialize the widget display state (Must be called after all functions are defined)
    toggleChatWindow(false); 
    
</script>
</html>