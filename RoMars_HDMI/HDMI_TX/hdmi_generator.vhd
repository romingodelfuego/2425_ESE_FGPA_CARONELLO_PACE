library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hdmi_generator is
	generic (
		-- Resolution
		h_res 	: natural := 720;
		v_res 	: natural := 480;

		-- Timings magic values (480p)
		h_sync	: natural := 61;
		h_fp	: natural := 58;
		h_bp	: natural := 18;

		v_sync	: natural := 5;
		v_fp	: natural := 30;
		v_bp	: natural := 9;

		h_total : natural := 857; 	-- somme de h_sync, h_fp hbp h_res
		v_total : natural := 524 -- somme de h_sync, h_fp hbp h_res
	);
	port (
		i_clk  		: in std_logic;
    		i_reset_n 	: in std_logic;
    		o_hdmi_hs   : out std_logic;
    		o_hdmi_vs   : out std_logic;
    		o_hdmi_de   : out std_logic;

		o_pixel_en : out std_logic;
		o_pixel_address : out natural range 0 to (h_res * v_res - 1);
		o_x_pixel_pos : out natural range 0 to (h_res - 1);
		o_y_pixel_pos : out natural range 0 to (v_res - 1);
		o_new_frame : out std_logic
  	);
end hdmi_generator;

architecture rtl of hdmi_generator is
	signal h_count : std_logic_vector(h_total downto 0);
	-- signal (registre) intermédiaire : avec une valeur par défaut et remis à zero dans le reset
	signal h_counter : natural range 0 to h_total:= 0;
	signal v_counter : natural range 0 to v_total:= 0;
	signal r_pixel_counter : natural range 0 to (h_res * v_res - 1);
	signal h_act : std_logic:='0';
	signal v_act : std_logic :='0';
begin
	process (i_clk,i_reset_n)
	begin
		-- Diviser frequence
		-- Remplir le h_count
		if (i_reset_n ='0') then
			h_counter <= 0;
			v_counter <= 0;
		elsif (rising_edge(i_clk)) then
			if (h_counter <h_total) then  
			h_counter <= h_counter +1;
			else			
				h_counter <= 0;
				if (v_counter < v_total) then
 					v_counter <= v_counter + 1;
				else 
					v_counter <= 0;
				end if;
			end if;

		if (h_act= '1') then
			o_x_pixel_pos <=h_counter-(h_sync+h_bp);
			r_pixel_counter <= r_pixel_counter +1;
		else 
			o_x_pixel_pos <=0;
		end if;
		if (v_act='1') then
			o_y_pixel_pos <=v_counter-(v_sync+v_bp);
		else 
			o_y_pixel_pos <=0;
			r_pixel_counter <= 0;
		end if;
	end if;
	end process;
		o_hdmi_hs <= '1' when h_counter < h_sync else
			'0';
		o_hdmi_vs <= '1' when v_counter < v_sync else
			'0';
		h_act <= '1' when ((h_total - h_fp > h_counter) and (h_counter > h_sync + h_bp)) else
			'0';
		v_act <= '1' when ((v_total - v_fp > v_counter) and (v_counter > v_sync + v_bp)) else
			'0';
		o_hdmi_de <= '1' when ((h_act= '1') and (v_act='1')) else 
			'0';
		o_pixel_address <= r_pixel_counter;
		
end architecture rtl;
