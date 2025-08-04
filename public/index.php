<?php

use Phalcon\Mvc\Micro;
use Phalcon\Http\Response;

// Create a new Phalcon Micro application
$app = new Micro();

// Set up the main route
$app->get('/', function () {
    $response = new Response();
    $response->setContentType('application/json', 'UTF-8');
    
    // Get request information
    $request = $this->request;
    $method = $request->getMethod();
    $path = $request->getURI();
    $query = $request->getQuery();
    
    // Prepare response data
    $responseData = [
        'status' => 'success',
        'message' => 'Phalcon REST API is working',
        'framework' => [
            'name' => 'Phalcon',
            'version' => phpversion('phalcon')
        ],
        'data' => [
            'method' => $method,
            'path' => $path,
            'query' => $query,
            'php_version' => phpversion(),
            'time' => date('Y-m-d H:i:s'),
        ]
    ];
    
    $response->setJsonContent($responseData);
    return $response;
});

// Handle other routes with a catch-all
$app->notFound(function () {
    $response = new Response();
    $response->setContentType('application/json', 'UTF-8');
    $response->setStatusCode(404, 'Not Found');
    
    $request = $this->request;
    
    $responseData = [
        'status' => 'error',
        'message' => 'Endpoint not found',
        'framework' => [
            'name' => 'Phalcon',
            'version' => phpversion('phalcon')
        ],
        'data' => [
            'method' => $request->getMethod(),
            'path' => $request->getURI(),
            'available_endpoints' => [
                'GET /' => 'Main API status endpoint',
                'GET /info.php' => 'PHP information page'
            ]
        ]
    ];
    
    $response->setJsonContent($responseData);
    return $response;
});

// Handle the application
try {
    $app->handle($_SERVER['REQUEST_URI']);
} catch (Exception $e) {
    $response = new Response();
    $response->setContentType('application/json', 'UTF-8');
    $response->setStatusCode(500, 'Internal Server Error');
    
    $responseData = [
        'status' => 'error',
        'message' => 'Internal server error',
        'framework' => [
            'name' => 'Phalcon',
            'version' => phpversion('phalcon')
        ],
        'error' => $e->getMessage()
    ];
    
    $response->setJsonContent($responseData);
    $response->send();
}
