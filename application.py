from flask import Flask, render_template, request
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler

application = Flask(__name__)
app = application

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/predictdata", methods=["GET", "POST"])
def predict_datapoint():
    if request.method == "GET":
        return render_template("home.html")

    from src.pipeline.predict_pipeline import CustomData, PredictPipeline  # <— move here

    data = request.form
    data = CustomData(
        gender=data["gender"],
        ethnicity=data["ethnicity"],
        parental_level_of_education=data["parental_level_of_education"],
        lunch=data["lunch"],
        test_preparation_course=data["test_preparation_course"],
        reading_score=data["reading_score"],
        writing_score=data["writing_score"],
    )

    pred_df = data.get_data_as_data_frame()
    predict_pipeline = PredictPipeline()
    results = predict_pipeline.predict(pred_df)
    return render_template("home.html", results=results[0])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
