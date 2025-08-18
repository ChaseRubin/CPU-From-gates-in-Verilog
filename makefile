# === CONFIG ===
TOP_MODULE = cpu_tb
OUTPUT = cpu.out
VCD = wave.vcd
FILELIST = files.f

# === DEFAULT TARGET ===
all: run

# === COMPILE ===
$(OUTPUT): $(FILELIST)
	iverilog -f $(FILELIST) -s $(TOP_MODULE) -o $(OUTPUT)

# === RUN SIMULATION ===
run: $(OUTPUT)
	vvp $(OUTPUT)

# === VIEW WAVEFORM ===
wave: run
	gtkwave $(VCD)

# === CLEAN UP ===
clean:
	rm -f $(OUTPUT) $(VCD)
