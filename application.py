from flask import Flask, render_template, request

application = Flask(__name__, template_folder="templates")  # ensure correct folder
app = application

@app.get("/health")
def health():
    return "OK", 200

@app.get("/")
def index():
    # TEMP: avoid templates until we confirm boot
    return "Hello from EB", 200

@app.route("/predictdata", methods=["GET", "POST"])
def predict_datapoint():
    if request.method == "GET":
        # return render_template("home.html")  # enable later
        return "Predict form", 200

    # Lazy-import heavy stuff so app can boot
    from src.pipeline.predict_pipeline import CustomData, PredictPipeline

    f = request.form
    data = CustomData(
        gender=f["gender"],
        ethnicity=f["ethnicity"],
        parental_level_of_education=f["parental_level_of_education"],
        lunch=f["lunch"],
        test_preparation_course=f["test_preparation_course"],
        reading_score=f["reading_score"],
        writing_score=f["writing_score"],
    )
    pred_df = data.get_data_as_data_frame()
    results = PredictPipeline().predict(pred_df)
    # return render_template("home.html", results=results[0])  # enable later
    return str(results[0]), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
