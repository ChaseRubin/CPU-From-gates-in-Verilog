module xor8 (
  input [7:0] a,
  input [7:0] b,
  output [7:0] y
);
  xor_gate u0 (a[0], b[0], y[0]);
  xor_gate u1 (a[1], b[1], y[1]);
  xor_gate u2 (a[2], b[2], y[2]);
  xor_gate u3 (a[3], b[3], y[3]);
  xor_gate u4 (a[4], b[4], y[4]);
  xor_gate u5 (a[5], b[5], y[5]);
  xor_gate u6 (a[6], b[6], y[6]);
  xor_gate u7 (a[7], b[7], y[7]);
endmodule
