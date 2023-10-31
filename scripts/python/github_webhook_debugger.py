'''
GitHub Webhook Debugger

This script provides a basic server setup to listen and display POST request payloads,
specifically tailored for GitHub webhooks. It assists developers in debugging
and understanding incoming webhook payloads.

Prerequisites:
- A system with Python 3.x installed.
- A publicly accessible endpoint if debugging webhooks from live repositories
  (tools like ngrok can help with this, or forward the port on your home router).

How to use:
- de path/to/script
- Run the script: python github_webhook_debugger.py
  - on some systems this might be python3 github_webhook_debugger.py
- Set up the webhook on GitHub and point it to your server's endpoint.
- When the webhook triggers, the payload will be printed to the console.

Todo:
- Add validation to verify payloads using GitHub's webhook secret for enhanced security.
- Implement logging to persist payloads for future reference.

Author: Christian Prior-Mamulyan (cprior@gmail.com)
Repository Location: https://github.com/rpapub/project-basturma-pipelines
LICENSE: CC-BY
'''


from http.server import BaseHTTPRequestHandler, HTTPServer

# Define a custom handler for HTTP POST requests
class WebhookHandler(BaseHTTPRequestHandler):
    """
    A custom HTTP request handler class designed to process incoming POST requests, 
    particularly tailored for payloads sent from GitHub webhooks. When a POST request 
    is received, the payload data (typically in JSON format representing events on 
    GitHub) is extracted and printed to the console.

    Extends:
    - BaseHTTPRequestHandler: Base class from the http.server module that provides 
      default implementations for handling HTTP requests.
    """

    # Method to handle HTTP POST requests
    # pylint: disable=invalid-name
    def do_POST(self):
        """
        Method overridden from BaseHTTPRequestHandler to handle HTTP POST 
        requests. It reads the content of the incoming request and prints it.

        """
        # Extract content length from headers to know how much data to read
        content_length = int(self.headers['Content-Length'])

        # Read the POST data based on the content length
        post_data = self.rfile.read(content_length)

        # Decode the byte data to UTF-8 and print to console
        print(post_data.decode('utf-8'))

        # Send a 200 OK response
        self.send_response(200)

        # End the headers for the HTTP response
        self.end_headers()

# Main execution starts here
if __name__ == "__main__":
    # Define the port number as a variable for easy changes
    PORT = 8008

    # Create server address using the defined port.
    # An empty string for IP means it listens on all available network interfaces.
    server_address = ('', PORT)

    # Initialize the HTTP server with our custom handler
    httpd = HTTPServer(server_address, WebhookHandler)

    # Print a startup message to the console
    print(f'Webhook server started on port {PORT}...')

    # Start the server to listen indefinitely for incoming requests
    httpd.serve_forever()
