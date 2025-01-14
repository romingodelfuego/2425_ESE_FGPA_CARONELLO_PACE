library ieee;
use ieee.std_logic_1164.all;
entity tuto_fpga is
	port (
		i_clk : in std_logic;
		i_rst_n : in std_logic;
		o_led : out std_logic_vector( 7 downto 0)
	);
end entity tuto_fpga;
architecture rtl of tuto_fpga is
	signal r_led : std_logic_vector(7 downto 0):= "10000000";
begin
	process(i_clk, i_rst_n)
		 variable counter: natural range 0 to 5000000 :=0;
	begin
		if (i_rst_n = '0') then
			counter := 0;
			r_led <= "10000000";
		elsif (rising_edge(i_clk)) then
			if (counter = 5000000) then
				r_led(6) <= r_led(7);
				r_led(6 downto 0) <= r_led(7 downto 1);
				r_led(7)<=r_led(0);
				counter := 0;
			else 
				counter := counter +1;
			end if;
		end if;
	end process;
	o_led <= r_led;
end architecture rtl;


