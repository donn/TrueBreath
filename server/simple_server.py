import os

import zstandard as zst
from bottle import request, post, get, run

from analyze import frames_from_file, calc_breathing_rate

__dir__ = os.path.dirname(os.path.abspath(__file__))


@get("/ping")
def health():
    return "pong"


@post("/<path>")
def upload(path):
    path = os.path.join(__dir__, path)
    open_fn = open
    if not path.endswith(".zst"):
        path += ".zst"
        open_fn = zst.open
    with open_fn(path, "wb") as f:
        f.write(request.body.read())
    frames, _, _, _ = frames_from_file(zst.open(path))
    breathing_rate = calc_breathing_rate(frames, 5)
    print(f"Breathing rate: {breathing_rate} Hz ({breathing_rate * 60} bpm)")


if __name__ == "__main__":
    run(host="0.0.0.0", port=8000)
