#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     10                         ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      600                        ;# X dimension of topography
set val(y)      100                        ;# Y dimension of topography
set val(stop)   12.0                       ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

$ns node-config -energyModel EnergyModel \
		-initialEnergy 1 \
		-txpPower 0.1 \
		-rxPower 0.0 \
		-idlePower 0.0 \
		-sensePower 0.00 \


#===================================
#        Nodes Definition        
#===================================

$ns node-config -initialEnergy 1
set n0 [$ns node]
$n0 set X_ 0
$n0 set Y_ 400
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set eng0 [$n0 energy]


$ns node-config -initialEnergy 1 
set n1 [$ns node]
$n1 set X_ 200
$n1 set Y_ 400
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set eng1 [$n1 energy]


$ns node-config -initialEnergy 1
set n2 [$ns node]
$n2 set X_ 400
$n2 set Y_ 400
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set eng2 [$n2 energy]

$ns node-config -initialEnergy 1
set n3 [$ns node]
$n3 set X_ 0
$n3 set Y_ 200
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set eng3 [$n3 energy]

# clusterhead
$ns node-config -initialEnergy 8
set n4 [$ns node]
$n4 set X_ 200
$n4 set Y_ 200
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set eng4 [$n4 energy]


$ns node-config -initialEnergy 1
set n5 [$ns node]
$n5 set X_ 400
$n5 set Y_ 200
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set eng5 [$n5 energy]

$ns node-config -initialEnergy 1
set n6 [$ns node]
$n6 set X_ 0
$n6 set Y_ 0
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set eng6 [$n6 energy]

$ns node-config -initialEnergy 1
set n7 [$ns node]
$n7 set X_ 200
$n7 set Y_ 0
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set eng7 [$n7 energy]


$ns node-config -initialEnergy 1
set n8 [$ns node]
$n8 set X_ 400
$n8 set Y_ 0
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set eng8 [$n8 energy]

# base station
$ns node-config -initialEnergy 1
set n9 [$ns node]
$n9 set X_ 200
$n9 set Y_ 100
$n9 set Z_ 0
$ns initial_node_pos $n9 20
set eng9 [$n9 energy]

#===================================
#        Functions        
#===================================

proc distance {x y z} {
    
    set n1_x 200
    set n1_y 200
    set n1_z 0
    set diffx [expr $n1_x-$x]
    set diffy [expr $n1_y-$y]
    set diffz [expr $n1_z-$z]
    set pow_x [pow $diffx 2]
    set pow_y [pow $diffy 2]
    set pow_z [pow $diffz 2]
    set total [expr $pow_x + $pow_y + $pow_z]
    return [sqrt $total]
}

proc tr_energyloss {k dist} {
    set total [expr $k* pow(10,-12) + $k* pow($dist,2) *13* pow(10,-16) * exp(0.0203*$dist) ]
    return $total
}

proc rcv_energyloss {k} {
    set total [expr $k*pow(10,-12) ]
    return $total
}


#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp12 [new Agent/TCP]
$ns attach-agent $n0 $tcp12
set sink4 [new Agent/TCPSink]
$ns attach-agent $n4 $sink4
$ns connect $tcp12 $sink4
$tcp12 set packetSize_ 1500

#Setup a TCP connection
set tcp13 [new Agent/TCP]
$ns attach-agent $n3 $tcp13
set sink9 [new Agent/TCPSink]
$ns attach-agent $n4 $sink9
$ns connect $tcp13 $sink9
$tcp13 set packetSize_ 1500

#Setup a TCP connection
set tcp14 [new Agent/TCP]
$ns attach-agent $n6 $tcp14
set sink11 [new Agent/TCPSink]
$ns attach-agent $n4 $sink11
$ns connect $tcp14 $sink11
$tcp14 set packetSize_ 1500

#Setup a TCP connection
set tcp15 [new Agent/TCP]
$ns attach-agent $n7 $tcp15
set sink8 [new Agent/TCPSink]
$ns attach-agent $n4 $sink8
$ns connect $tcp15 $sink8
$tcp15 set packetSize_ 1500

#Setup a TCP connection
set tcp16 [new Agent/TCP]
$ns attach-agent $n8 $tcp16
set sink7 [new Agent/TCPSink]
$ns attach-agent $n4 $sink7
$ns connect $tcp16 $sink7
$tcp16 set packetSize_ 1500

#Setup a TCP connection
set tcp17 [new Agent/TCP]
$ns attach-agent $n5 $tcp17
set sink10 [new Agent/TCPSink]
$ns attach-agent $n4 $sink10
$ns connect $tcp17 $sink10
$tcp17 set packetSize_ 1500

#Setup a TCP connection
set tcp18 [new Agent/TCP]
$ns attach-agent $n2 $tcp18
set sink6 [new Agent/TCPSink]
$ns attach-agent $n4 $sink6
$ns connect $tcp18 $sink6
$tcp18 set packetSize_ 1500

#Setup a TCP connection
set tcp19 [new Agent/TCP]
$ns attach-agent $n1 $tcp19
set sink5 [new Agent/TCPSink]
$ns attach-agent $n4 $sink5
$ns connect $tcp19 $sink5
$tcp19 set packetSize_ 1500

#Setup a TCP connection
set tcp22 [new Agent/TCP]
$ns attach-agent $n4 $tcp22
set sink21 [new Agent/TCPSink]
$ns attach-agent $n9 $sink21
$ns connect $tcp22 $sink21
$tcp22 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================

# k = rate
set k [expr 5*8*pow(10,6)]
set d_nodes_plus 50

# d = distance between cluster head and node
set d_nodes_cross [ expr 50 * 1.41 ] 
set d_base_station 100


set count 0

while { $eng0 > 0 || $eng1 > 0 || $eng2 > 0 || $eng3 > 0 || $eng5 > 0 || $eng6 > 0 || $eng7 > 0 || $eng8 > 0 && $eng4 > 0 } {

	#Setup a FTP Application over TCP connection
	set ftp0 [new Application/FTP]
	$ftp0 attach-agent $tcp12
	$ns at 1.0 "$ftp0 start"
	$ns at 2.0 "$ftp0 stop"
	set loss0 [ tr_energyloss $k  $d_nodes_cross ]
	set eng0 [expr $eng0 - $loss0 ]

	#Setup a FTP Application over TCP connection
	set ftp2 [new Application/FTP]
	$ftp2 attach-agent $tcp19
	$ns at 2.1 "$ftp2 start"
	# TDMA
	$ns at 3.0 "$ftp2 stop"
	set loss1 [ tr_energyloss $k  $d_nodes_plus ]
	set eng1 [expr $eng1 - $loss1 ]

	#Setup a FTP Application over TCP connection
	set ftp3 [new Application/FTP]
	$ftp3 attach-agent $tcp18
	$ns at 3.1 "$ftp3 start"
	$ns at 4.0 "$ftp3 stop"
	set loss2 [ tr_energyloss $k  $d_nodes_cross ]
	set eng2 [expr $eng2 - $loss2 ]

	#Setup a FTP Application over TCP connection
	set ftp4 [new Application/FTP]
	$ftp4 attach-agent $tcp17
	$ns at 4.1 "$ftp4 start"
	$ns at 5.0 "$ftp4 stop"
	set loss3 [ tr_energyloss $k  $d_nodes_plus ]
	set eng5 [expr $eng5 - $loss3 ]

	#Setup a FTP Application over TCP connection
	set ftp5 [new Application/FTP]
	$ftp5 attach-agent $tcp16
	$ns at 5.1 "$ftp5 start"
	$ns at 6.0 "$ftp5 stop"
	set loss4 [ tr_energyloss $k  $d_nodes_cross ]
	set eng8 [expr $eng8 - $loss4 ]

	#Setup a FTP Application over TCP connection
	set ftp6 [new Application/FTP]
	$ftp6 attach-agent $tcp15
	$ns at 6.1 "$ftp6 start"
	$ns at 7.0 "$ftp6 stop"
	set loss5 [ tr_energyloss $k  $d_nodes_plus ]
	set eng7 [expr $eng7 - $loss5 ]

	#Setup a FTP Application over TCP connection
	set ftp7 [new Application/FTP]
	$ftp7 attach-agent $tcp14
	$ns at 7.1 "$ftp7 start"
	$ns at 8.0 "$ftp7 stop"
	set loss6 [ tr_energyloss $k  $d_nodes_cross ]
	set eng6 [expr $eng6 - $loss6 ]

	#Setup a FTP Application over TCP connection
	set ftp8 [new Application/FTP]
	$ftp8 attach-agent $tcp13
	$ns at 8.1 "$ftp8 start"
	$ns at 9.0 "$ftp8 stop"
	set loss7 [ tr_energyloss $k  $d_nodes_plus ]
	set eng3 [expr $eng3 - $loss7 ]

	#Setup a FTP Application over TCP connection
	set ftp9 [new Application/FTP]
	$ftp9 attach-agent $tcp22
	$ns at 10.1 "$ftp9 start"
	$ns at 11.1 "$ftp9 stop"
	#set loss8_1 [ tr_energyloss $k*8  $d_nodes_plus ]
	set loss81 [ tr_energyloss $k  $d_base_station ]
	set loss82 [ rcv_energyloss $k ]
	set eng4 [expr $eng4 - $loss81 - $loss82 ]

	set count [expr $count + 1 ]
        
        puts stdout $count
	puts stdout $eng0
	puts stdout $eng1
	puts stdout $eng2
	puts stdout $eng3
	puts stdout $eng4
	puts stdout $eng5
	puts stdout $eng6
	puts stdout $eng7
	puts stdout $eng8
	puts stdout "\n\n"
}


puts stdout "network life: $count"

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
