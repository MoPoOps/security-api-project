from flask import Flask, jsonify
import random

# 1 start the application
app = Flask(__name__)

# 2 my list of security tips
security_tips = [
    "Always use Multi Factor Authentication (MFA).",
    "Never reuse passwords across different critical accounts.",
    "Be cautious of unsolicited emails demanding immediate action.",
    "Keep your software and operating systems updated to patch vulnerabilities.",
    "Secure your CI/CD pipeline like production; A hacked pipeline means hacked deployments.",
    "Scan your code, dependencies, and containers automatically to catch issues early.",
    "Store secrets in a secrets manager, never in code, repos, or CI variables.",
    "Use small, trusted container images and avoid running containers as root.",
    "Give cloud permissions sparingly, only what each service or user truly needs.",
    "Scan your Terraform and Kubernetes files before deploying to avoid misconfigurations.",
    "Turn on logging everywhere so you can see who did what and when.",
    "Use short lived cloud credentials that expire instead of long term access keys."
    "Use the Principle of Least Privilege and only give access to those who absolutely need it."
]

# 3 create the api route
@app.route('/api/tip', methods=['GET'])
def get_random_tip():
    # pick a random tip from my list
    selected_tip = random.choice(security_tips)
    
    # return it as json format
    return jsonify({
        "status": "success",
        "author": "mopo",
        "cyber_tip": selected_tip
    })

# 4 turn the server on
if __name__ == '__main__':
    # listen on all network interfaces (0.0.0.0) at port 8080
    app.run(host='0.0.0.0', port=8080)