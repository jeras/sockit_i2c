module sockit_i2c_tb ();

wire scl;  // serial clock
wire sda;  // serial data

pullup pullup_scl (scl);
pullup pullup_sda (sda);

logic [7:0] dummy;

initial begin
  $dumpfile("waveform.vcd");
  $dumpvars(0, sockit_i2c_tb);
end

initial begin
  i2c_master.i2c_transfer (7'b0100110, 1'b1, 8'ha5, dummy);
  # 10us;
  $finish;
end

sockit_i2c_master_model i2c_master (
  .scl  (scl),
  .sda  (sda)
);

sockit_i2c_slave_model i2c_slave (
  .scl  (scl),
  .sda  (sda)
);

endmodule : sockit_i2c_tb
