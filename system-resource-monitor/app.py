from flask import Flask, jsonify, render_template
import psutil

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/metrics")
def metrics():
    cpu_usage = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()

    data = {
        "cpu_usage_percent": cpu_usage,
        "memory_total_gb": round(memory.total / (1024 ** 3), 2),
        "memory_used_gb": round(memory.used / (1024 ** 3), 2),
        "memory_usage_percent": memory.percent
    }

    return jsonify(data)

if __name__ == "__main__":
    # 0.0.0.0 allows access over the network
    app.run(host="0.0.0.0", port=5000, debug=True)
