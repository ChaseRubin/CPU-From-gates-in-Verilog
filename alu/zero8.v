module zero8(
  input [7:0] a,
  output [7:0] y
);

wire [7:0] not_a;

not_gate u0(a[0], not_a[0]);
not_gate u1(a[1], not_a[1]);
not_gate u2(a[2], not_a[2]);
not_gate u3(a[3], not_a[3]);
not_gate u4(a[4], not_a[4]);
not_gate u5(a[5], not_a[5]);
not_gate u6(a[6], not_a[6]);
not_gate u7(a[7], not_a[7]);

and_gate u8(a[0], not_a[0], y[0]);
and_gate u9(a[1], not_a[1], y[1]);
and_gate u10(a[2], not_a[2], y[2]);
and_gate u11(a[3], not_a[3], y[3]);
and_gate u12(a[4], not_a[4], y[4]);
and_gate u13(a[5], not_a[5], y[5]);
and_gate u14(a[6], not_a[6], y[6]);
and_gate u15(a[7], not_a[7], y[7]);

endmodule