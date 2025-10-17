<?php

$apiKey = getenv('OPENROUTER_API_KEY') ?: '$OPENROUTER_API_KEY';

// Read input from the frontend
$input = json_decode(file_get_contents('php://input'), true);
$userMessage = trim($input['message'] ?? '');


if (!$userMessage) {
    http_response_code(400);
    echo json_encode(['error' => 'No message provided.']);
    exit;
}

// Prepare the payload for OpenRouter API
// Using DeepSeek Chat v3.1 model
/* Example cURL request:
    curl https://openrouter.ai/api/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -d '{
    "model": "deepseek/deepseek-chat-v3.1:free",
    "messages": [
        {
        "role": "user",
        "content": "What is the meaning of life?"
        }
    ]
    
    }'
*/

$payload = [
    "model" => "deepseek/deepseek-chat-v3.1:free",
    "messages" => [
        ["role" => "user", "content" => $userMessage]
    ]
];

// Send the request
$ch = curl_init('https://openrouter.ai/api/v1/chat/completions');
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $apiKey
    ],
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => json_encode($payload)
]);

$response = curl_exec($ch);

if (curl_errno($ch)) {
    http_response_code(500);
    echo json_encode(['error' => 'cURL error: ' . curl_error($ch)]);
    curl_close($ch);
    exit;
}

curl_close($ch);

// Decode response and extract AI reply
$data = json_decode($response, true);
$reply = $data['choices'][0]['message']['content'] ?? 'No response from AI.';

// Return as JSON
header('Content-Type: application/json');
echo json_encode(['reply' => $reply]);
