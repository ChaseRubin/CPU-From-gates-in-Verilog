module and8 (
  input [7:0] a,
  input [7:0] b,
  output [7:0] y
);
  and_gate u0 (a[0], b[0], y[0]);
  and_gate u1 (a[1], b[1], y[1]);
  and_gate u2 (a[2], b[2], y[2]);
  and_gate u3 (a[3], b[3], y[3]);
  and_gate u4 (a[4], b[4], y[4]);
  and_gate u5 (a[5], b[5], y[5]);
  and_gate u6 (a[6], b[6], y[6]);
  and_gate u7 (a[7], b[7], y[7]);
endmodule
