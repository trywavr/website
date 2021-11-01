module Wavr.CracklePW where

import Data.List (List(..), (:))
import Data.NonEmpty ((:|))
import Data.Tuple.Nested ((/\))
import WAGS.Lib.Piecewise (APFofT, makeLoopingPiecewise)

pw'fis2 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.5422006867340954 /\ 0.2549054980212019) : (1.0964876060607045 /\ 0.2866897888368455) : (1.2513281774559555 /\ 0.027565546602062008) : (2.2230469245089917 /\ 0.5518255587745736) : (2.256021924535522 /\ 0.07476986711268785) : (2.632737624061379 /\ 0.7171914582728981) : (2.8003958375800355 /\ 0.07281714818508234) : (3.3594249331638215 /\ 0.35484024823233595) : (3.7895746005312345 /\ 0.03411864473353077) : (4.233787451179417 /\ 0.34362871691838337) : (4.874156661510252 /\ 0.5444458770761722) : (5.710896422951725 /\ 0.10206662205065031) : (6.148806721879319 /\ 0.7559886585065201) : (6.844182361789181 /\ 0.6784755229663658) : (7.5633030238828285 /\ 0.8799587712999865) : (8.417633759125629 /\ 0.061599152368699284) : (8.565077350193665 /\ 0.47293896400409297) : (8.861471481481534 /\ 0.17307195803941666) : (9.364414325358277 /\ 0.24005877400065168) : (9.907007889609027 /\ 0.08152508145607196) : Nil) :: APFofT Number
pw'fis3 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.9983629599644634 /\ 0.8489519740072194) : (1.7996925123650347 /\ 0.42081006960372047) : (2.03087698315163 /\ 0.9380139631782252) : (2.862637173096511 /\ 0.13642212859518443) : (2.9701828660676024 /\ 0.4590844282865225) : (3.3780962158578163 /\ 0.9878009435188679) : (3.7705008722576396 /\ 0.3872357998242565) : (3.879830206379726 /\ 0.28306805246519695) : (4.603491022126862 /\ 0.46252412963781475) : (4.8390112620169425 /\ 0.049429894251068585) : (5.5219302188746 /\ 0.47975277815109196) : (6.181145583890251 /\ 0.4317768521528087) : (6.670013616778246 /\ 0.17519416938289323) : (7.450210635185565 /\ 0.38396969304549566) : (7.56379201658715 /\ 0.19119096917546974) : (8.46089311079969 /\ 0.28576839075666904) : (9.021793480433686 /\ 0.8754645334742109) : (9.748428870790432 /\ 0.8880648149567164) : (10.488447346885469 /\ 0.6293017465423201) : (11.286042766802858 /\ 0.32225486112902035) : Nil) :: APFofT Number
pw'cis4 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.03152848310264811 /\ 0.5431428209802326) : (0.16928130399709385 /\ 0.4999121231341984) : (1.010839647408605 /\ 0.18915911813592123) : (1.3145591315943506 /\ 0.5543418477373124) : (1.7413894293073573 /\ 0.11827084445637126) : (1.78135577358215 /\ 0.18769474375920536) : (1.8696976282679514 /\ 0.9222712388105064) : (2.4762285678702742 /\ 0.8277822724210182) : (2.7296289309829778 /\ 0.6805455138722052) : (3.461676051050053 /\ 0.34621401372960536) : (4.141564494406116 /\ 0.21979164721193933) : (4.788159402679538 /\ 0.7773429133106408) : (4.930336184998201 /\ 0.15681609779264405) : (5.683436573986029 /\ 0.2806694849821) : (6.039548023001139 /\ 0.2889001582499182) : (6.152067768036245 /\ 0.18566534240112442) : (7.013204439164817 /\ 0.8792469286770158) : (7.932193332635767 /\ 0.0331687814880538) : (8.373128145861918 /\ 0.8118127378776453) : (9.084084404915803 /\ 0.28809553050088954) : Nil) :: APFofT Number
pw'fis4 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.7683353631648429 /\ 0.8604532107419834) : (1.3007239578289531 /\ 0.019190178024446447) : (2.2564998140230794 /\ 0.27401291002348005) : (2.546517732659574 /\ 0.06604863085110735) : (3.3220282527502727 /\ 0.14462788708004692) : (3.8569767883356043 /\ 0.559726836150061) : (4.433743438557766 /\ 0.5740922951095858) : (4.650318562049563 /\ 0.22193569870072494) : (5.177423681860775 /\ 0.36675647234781283) : (6.114288430692959 /\ 0.2770459035594788) : (6.899861857878692 /\ 0.021835717576356273) : (7.661842056185945 /\ 0.6004188735239389) : (8.040070482190801 /\ 0.9815600715477879) : (8.510242139487508 /\ 0.495419620980425) : (9.083412938651554 /\ 0.41745067363438915) : (9.642532360167344 /\ 0.6869481180464561) : (10.572313957374943 /\ 0.2807230033441209) : (11.197228829681928 /\ 0.984319839233616) : (11.945066185472337 /\ 0.9953153124661154) : (12.160079317587499 /\ 0.4475167366419741) : Nil) :: APFofT Number
pw'a4 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.029016351665690943 /\ 0.5357254941779636) : (0.6295055021914393 /\ 0.16002311915171397) : (1.5846022293090631 /\ 0.30183001578299595) : (1.8410507573458632 /\ 0.9089315579085016) : (2.1681980966603973 /\ 0.6157512200968538) : (2.750227692038276 /\ 0.6934557244440054) : (3.3272822868182663 /\ 0.9283360651145327) : (3.7464573740955944 /\ 0.7777611672240377) : (3.816857837335187 /\ 0.38990576434787627) : (4.182097995291977 /\ 0.9844786428399827) : (5.136573033214302 /\ 0.6195296819686321) : (5.516003341450643 /\ 0.5985484600561034) : (5.996487141373492 /\ 0.8294733182351444) : (6.506357403397338 /\ 0.21171286263866718) : (7.077842241535693 /\ 0.9841247010507841) : (7.248229988258144 /\ 0.8492886487504802) : (7.650075925116248 /\ 0.22658978540653607) : (8.283102576811055 /\ 0.5659746889058102) : (8.494933142083465 /\ 0.2820077035516856) : (9.43608410256347 /\ 0.5226123911875973) : Nil) :: APFofT Number
pw'cis5 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.7822160736628383 /\ 0.3764736285500151) : (0.9215736741819939 /\ 0.8479565646813396) : (1.2089657572371064 /\ 0.9615275010742746) : (1.6634344901210842 /\ 0.7539731138168875) : (2.508018911796096 /\ 0.9420208794721923) : (3.410636841669017 /\ 0.6709406126049109) : (3.456505819143908 /\ 0.5683392704238954) : (3.8841512241600036 /\ 0.7508039665623606) : (4.828796515088205 /\ 0.27722877412961977) : (4.979080899051095 /\ 0.06435880711947917) : (5.500935030636847 /\ 0.9209873991992851) : (5.798988720407817 /\ 0.11504239951492712) : (5.923368597692833 /\ 0.5477578805915603) : (6.140154563012377 /\ 0.9474789271607552) : (6.35512886798808 /\ 0.5254518891597083) : (6.418964158270857 /\ 0.35733530897658294) : (7.341796002542271 /\ 0.9359592349681046) : (7.972630626758022 /\ 0.39816530717605825) : (8.332651776663687 /\ 0.41670281150340494) : (8.373327184773379 /\ 0.9007203912861839) : Nil) :: APFofT Number
pw'e5 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.7944244540759613 /\ 0.8285105907954768) : (1.620712842588642 /\ 0.00046199121660006615) : (2.5076653924205905 /\ 0.12443980488760531) : (3.3341234468321574 /\ 0.835031191334685) : (3.383053485975012 /\ 0.3153196913199363) : (4.0289605359695875 /\ 0.39128880429443424) : (4.429368440724433 /\ 0.04180835654852855) : (5.161498715578152 /\ 0.8685012201675475) : (6.03693368309481 /\ 0.444633426427116) : (6.3740785888119715 /\ 0.8794679849075772) : (6.382826749235921 /\ 0.34968176413171614) : (6.881278122517389 /\ 0.6322290797197296) : (7.528714437334261 /\ 0.6673604752128903) : (8.311651371289136 /\ 0.7686563544621825) : (8.782854986354012 /\ 0.4626792269568055) : (8.860226908244849 /\ 0.3418102376411619) : (8.897415413189576 /\ 0.23812509346968358) : (9.265785277239383 /\ 0.42201832373851356) : (9.562590158539807 /\ 0.6832310641592193) : (10.260467283730017 /\ 0.7336405650272784) : Nil) :: APFofT Number
pw'gis5 = makeLoopingPiecewise ((0.0 /\ 0.0) :| (0.4806998038521386 /\ 0.054539328361108974) : (1.2172290323484085 /\ 0.6710862001252952) : (1.5729075569471296 /\ 0.44555709379062436) : (1.73389554968445 /\ 0.1095997146112101) : (1.837632808223987 /\ 0.0842274478014362) : (2.1693239389861496 /\ 0.19795721558509072) : (2.634884753308084 /\ 0.06609561904431438) : (3.5489019687218577 /\ 0.7845005286319974) : (4.4704926411504955 /\ 0.10801430566228354) : (4.572522559151338 /\ 0.3984761982298265) : (4.8212910209486495 /\ 0.31817571685422485) : (5.326153133321692 /\ 0.03327174932912591) : (5.975624178914256 /\ 0.542875950195469) : (6.875736581347803 /\ 0.6559479598686272) : (6.8822597517402215 /\ 0.019122065134898003) : (7.566785109431311 /\ 0.5077783908260505) : (7.638213571179782 /\ 0.18828653199422052) : (8.596044415200877 /\ 0.7130966692208136) : (9.11043493650848 /\ 0.4695977047494254) : (10.011402109470849 /\ 0.525289140918475) : Nil) :: APFofT Number