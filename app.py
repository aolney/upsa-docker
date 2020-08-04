# NOTE: THIS IS INCOMPLETE/NOT FUNCTIONAL BECAUSE A SIMPLE API 
# (WHICH THIS WOULD WRAP AS A SERVICE) DOES NOT YET EXIST
from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/api/getParaphrase', methods=['GET', 'POST'])
def api_getParaphrase():
    content = request.get_json()
    result = getParaphrase( content['sentence']) #TODO: IMPLEMENT IN SIMPLE API
    return jsonify(result)

# Instructions/help
@app.route('/')
def api_help():
    return 'API for UPSA'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')