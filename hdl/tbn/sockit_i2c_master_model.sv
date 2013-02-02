module sockit_i2c_master_model #(
  parameter real T_SCL,
  parameter real T_SDA
)(
  inout logic scl,  // serial clock
  inout logic sda   // serial data
);

logic scl_o, scl_e;
logic sda_o, sda_e;

bufif1 buf_scl (scl , scl_o, scl_e); 
bufif1 buf_sda (sda , sda_o, sda_e); 

// delay variables initialized to delay parameters
real t_unit = 10ns;

// after power-up, put the master into an idle state
initial begin
  scl_e = 1'b0;
  sda_e = 1'b0;
  scl_o = 1'b0;
  sda_o = 1'b0;
end

task i2c_start;
begin
  sda_e = 1'b1;
  # t_unit;
  scl_e = 1'b1;
  # t_unit;
end
endtask : i2c_start

task i2c_stop;
begin
  scl_e = 1'b0;
  # t_unit;
  sda_e = 1'b0;
  # t_unit;
end
endtask : i2c_stop

task i2c_bit (
  input  logic bit_i,
  output logic bit_o
);
begin
  sda_e = ~bit_i;
  # t_unit;
  scl_e = 1'b0;
  # 1ns;
  bit_o = sda;
  # t_unit;
  scl_e = 1'b0;
  # t_unit;
end
endtask : i2c_bit

task i2c_byte (
  input  logic [7:0] byte_i,
  input  logic       ack_i,
  output logic [7:0] byte_o,
  output logic       ack_o
);
begin
  for (int b=7; b>0; b--)  i2c_bit (byte_i[b], byte_o[b]);
  i2c_bit (ack_i, ack_o);
end
endtask : i2c_byte

task i2c_transfer (
  input  logic [6:0] id,
  output logic       rw,
  output logic [7:0] data_i,
  output logic [7:0] data_o
);
  logic [7:0] dat;
  logic       ack;
begin
  i2c_start;
  i2c_byte({id, rw}, 1'bz, dat, ack);
  i2c_byte(data_i, 1'bz, data_o, ack);
  i2c_stop;
end
endtask : i2c_transfer

endmodule : sockit_i2c_master_model
