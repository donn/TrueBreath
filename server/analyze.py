import click
import struct
import numpy as np
import zstandard as zst
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider


def frames_from_file(io):
    frames = []
    differences = []
    while True:
        try:
            # Swift Ints are 64-bit
            width_b = io.read(8)
            height_b = io.read(8)
            if len(width_b) < 8 or len(height_b) < 8:
                raise EOFError()
            width: int = struct.unpack("<q", width_b)[0]
            height: int = struct.unpack("<q", height_b)[0]
            frame_size = width * height
            frame = io.read(frame_size * 2)  # Each pixel is a float16
            frame_unpacked = struct.unpack(f"<{'e' * frame_size}", frame)
            arr = np.array(frame_unpacked)
            arr.shape = (
                height,
                width,
            )
            arr = np.nan_to_num(arr, nan=5.12)  # set nans from to very far
            arr *= 100  # m to cm
            arr[arr > 128] = 512
            if len(frames):
                difference = arr - frames[-1]
                differences.append(difference * 100)
            frames.append(arr)
        except EOFError:
            break
    return (frames, differences, width, height)


def frame_areas(frames):
    last_area = np.count_nonzero(frames[0] < 128)
    areas = []
    diffs = []
    for frame in frames:
        area = np.count_nonzero(frame < 128)
        diff = area - last_area
        last_area = area
        areas.append(area)
        diffs.append(diff)

    return areas, diffs


def calc_breathing_rate(frames, fps, aux_data=None):
    if aux_data is None:
        aux_data = {}

    N = len(frames)
    dx = 1 / fps

    x = np.linspace(0, N * dx, N)
    y, ydiff = frame_areas(frames)

    # The frequency domain
    xf = np.linspace(0, 1 / (2 * dx), N // 2)

    ydiff_f = np.fft.fft(ydiff)
    # ydiff_f_scaled = 2.0 / N * np.abs(ydiff_f[: N // 2])

    ydiff_f_clean = np.abs(ydiff_f.copy())
    _cutoff_idx = None
    for i, f in enumerate(xf):
        if f > 1:
            _cutoff_idx = i
            break

    for i, _ in enumerate(ydiff_f_clean):
        if i > _cutoff_idx:
            ydiff_f_clean[i] = 0
    max_idx = np.argmax(ydiff_f_clean)
    breathing_rate = xf[max_idx]
    aux_data["N"] = len(frames)
    aux_data["x"] = x
    aux_data["xf"] = xf
    aux_data["y"] = y
    aux_data["ydiff_f_clean"] = ydiff_f_clean
    return breathing_rate


@click.command()
@click.option(
    "--fps",
    default=5,
)
@click.option(
    "--plot",
    "show_plot",
    type=click.Choice(["none", "area", "frames", "diffs"]),
    default="none",
)
@click.argument("file")
def main(fps, show_plot, file):
    if file.endswith(".zst"):
        io = zst.open(file, "rb")
    else:
        io = open(file, "rb")

    frames, differences, width, height = frames_from_file(io)

    print(
        f"Read a {width}x{height} video with {len(frames)} frames ({fps} fps, duration: {len(frames) / fps}s)"
    )

    aux_data = {}
    breathing_rate = calc_breathing_rate(frames, fps, aux_data)

    print(f"Breathing rate: {breathing_rate} Hz ({breathing_rate * 60} bpm)")

    if show_plot in ["area"]:
        N = aux_data["N"]
        ydiff_f_clean = aux_data["ydiff_f_clean"]
        x = aux_data["x"]
        xf = aux_data["xf"]
        y = aux_data["y"]

        ydiff_f_clean_scaled = 2.0 / N * np.abs(ydiff_f_clean[: N // 2])
        _, ax_at = plt.subplots()
        ax_at.plot(x, y)
        ax_at.set_title("Difference in area over time")
        ax_at.set_xlabel("time (s)")
        ax_at.set_ylabel("area delta from last frame (pixels)")

        _, ax_fq = plt.subplots()
        ax_fq.plot(xf, ydiff_f_clean_scaled)
        ax_fq.set_title("Frequency domain (after low-pass filter)")
        ax_fq.set_xlabel("frequency (Hz)")
        ax_fq.set_ylabel("amplitude")

        plt.show()
    elif show_plot in ["frames", "diffs"]:
        visualize = differences if show_plot == "diffs" else frames
        v_normalized = [frame * 255 / frame.max() for frame in visualize]

        _, ax = plt.subplots()
        im_h = ax.imshow(np.flip(visualize[0]))
        ax_depth = plt.axes([0.23, 0.02, 0.56, 0.04])
        slider_depth = Slider(ax_depth, "depth", 0, len(visualize) - 1, valinit=0)

        def update_depth(val):
            global idx
            idx = int(val)
            im_h.set_data(np.flip(v_normalized[idx]))

        slider_depth.on_changed(update_depth)

        plt.show()


if __name__ == "__main__":
    main()
