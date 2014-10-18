<?php
class app extends spController{
    function __construct(){
	 	//自动执行父类构造函数
        parent::__construct();
        global $__action;
        if(!tokenIsNotNeed($__action)){//判断action 接口是否需要token
            if(!$_REQUEST['token']){
				echo json_encode(array('state' => 1,'err-code' => 'x600')); 
				exit;
			}
			if(!tokenIsNotExist()){
				echo json_encode(array('state' => 1,'err-code' => 'x601')); 
				exit;
			}
			if(!tokenIsNotRight()){
				echo json_encode(array('state' => 1,'err-code' => 'x602')); 
				exit;
			}
            if(!$_REQUEST['m_code']){
				echo json_encode(array('state' => 1,'err-code' => 'x604')); 
				exit;
			}
        }
        //登记录 中 链接一次时间距离现在时间超过5分钟 删除
        loginStateChange();
        //验证码存在时间超过10分钟 删除
        vcodeClear();
    }
    //获取广告图信息
    function getAdv(){
        $province = "";$city="";$district="";
    if($adv_eara != ""){
	$mcitys =split("-",$adv_eara);
	if(count($mcitys) == 3){
		$district=$mcitys[2];
		$city=$mcitys[1];
		$province=$mcitys[0];
	}
    if(count($mcitys) == 2){
		$city=$mcitys[1];
		$province=$mcitys[0];
	}
    if(count($mcitys) == 1){
		$province=$mcitys[0];
	}
      }
    	
        $sql = ' select adv_id,adv_path,adv_title,adv_sort,adv_eara,adv_s_date,adv_e_date,
        adv_s_time,adv_e_time,adv_url,adv_addtime  from bc_adv  ';
        $sql.= ' where (adv_eara ="" or ';
        $sql.= ' adv_eara ="'.$_REQUEST['m_eara'].'" or ';
        $sql.= ' adv_eara ="'.$province.'-'.$city.'" or ';
        $sql.= ' adv_eara ="'.$province.'") ';
        $sql .= ' and date(adv_s_date) <= "'.date("Y-m-d").'"';
        $sql .= ' and date(adv_e_date) >= "'.date("Y-m-d").'"';
        $sql .= ' and UNIX_TIMESTAMP(concat(curdate()," ",adv_s_time,":00")) <= UNIX_TIMESTAMP(NOW()) ';
        $sql .= ' and UNIX_TIMESTAMP(concat(curdate()," ",adv_e_time,":00")) >= UNIX_TIMESTAMP(NOW()) ';
        // $sql .= ' and date(concat(curdate()," ",adv_e_time,":00")) >= "'.date("Y-m-d H:i:s").'"';
        //$sql .= ' and date(adv_e_time) >= "'.date("H:i").'"';
        $sql.= ' order by adv_sort <> 0 desc,adv_sort asc ';
       // echo $sql;
        $result = get_info_by_sql($sql);
        //if(false === $result){
        //    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！
        ///    die();
        //}
        
        echo json_encode(array('list' => $result,'state' => 0,'err-code' => ''));
        unset($result,$sql);
    }
    //获取app版本更新信息
    function getApkUpdata(){
        //无新版本
        // $cnt = 0;
        $apk_path = '';
        $sql = ' select apk_versionName,apk_versionCode,apk_path from bc_apk ';
        $sql.= ' where  apk_versionCode  > '.(int)$_REQUEST['versionCode'];
        $sql.= ' and apk_isdel = 0 ';
        $sql.= ' order by apk_versionCode desc ';
        $result = get_info_by_sql($sql);
        //if(false === $result){
        //    echo json_encode(array('state' => 1,'err-code' => 'x001'));
        //    die();
        //}
        $apk_path = $result[0]['apk_path'];
        $apk_versionName = $result[0]['apk_versionName'];
        $apk_versionCode = $result[0]['apk_versionCode'];
        if(!$apk_path)$apk_path = '';
        echo json_encode(array('apk_path' => $apk_path,'apk_versionName' => $apk_versionName,'apk_versionCode' => $apk_versionCode,'state' => 0,'err-code' => ''));
        unset($result,$sql);
    }
    //登录
	function login(){
	 	//email and name 002 账号或密码不正确
	 	$cnt = 0;
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and member_md5password = "'.md5($_REQUEST['m_pwd']).'"';
	 	$sql.= ' and member_state = 0 ';
	 	
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
            die();
	 	}
	 	unset($result,$sql);
	    $sql = ' select member_code,member_name,member_state,
	    member_loc_share,member_voice_broadcast,member_sound_reminder,member_shaking_reminder
	    ,member_receive_info,member_receive_range
	      from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and member_md5password = "'.md5($_REQUEST['m_pwd']).'"';
	 	$result = get_info_by_sql($sql);
	 	$member_state = $result[0]['member_state'];
	 	$member_code = $result[0]['member_code'];
	 	$member_name = $result[0]['member_name'];
	 	
	 	$member_loc_share = $result[0]['member_loc_share'];
	 	$member_voice_broadcast = $result[0]['member_voice_broadcast'];
	 	$member_sound_reminder = $result[0]['member_sound_reminder'];
	 	$member_shaking_reminder = $result[0]['member_shaking_reminder'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	
	 	unset($result,$sql);
	 	if((int)$member_state == 1){
	 		echo json_encode(array('state' => 1,'err-code' => 'x603')); 
            die();
	 	}
	 	
	 	//今天是否登录过
	 	$cnt = 0;
	 	$sql = ' select count(login_log_id) as cnt from bc_login_log ';
	 	$sql.= ' where login_log_m_code ="'.$member_code.'"';
	 	$sql.= ' and login_log_day = "'.date('Y-m-d').'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$row['login_log_c_time'] = date('Y-m-d H:i:s');
	 	$login_log_token = md5(date('YmdHis'));
	 	$row['login_log_token'] = $login_log_token;
	 	$row['login_state'] = 0;
	 	$row['login_mobile'] = $_REQUEST['m_mobile'];
	 	if($cnt == 0){
	 	    $row['login_log_time'] = date('Y-m-d H:i:s');
	 	    $row['login_log_m_code'] = $member_code;
	 	    $row['login_log_day'] = date('Y-m-d'); 
	 	    $result = add_login_log($row);
	 	    if(false === $result){
	 	    	echo json_encode(array('state' => 1,'err-code' => 'x001'));
	 	    	die();
	 	    }
	 	}else{
	 	    $result = update_login_log($member_code,date('Y-m-d'),$row);
	 	    if(false === $result){
	 	    	echo json_encode(array('state' => 1,'err-code' => 'x001')); 
	 	    	die();
	 	    }
	 	}
	    //身份认证
		$rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code ="'.$member_code.'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_idcard = 0;
	 	}else{
	 	    $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ic_auth_state= $result[0]['ic_auth_state'];
	 	    $rz_idcard = (int)$ic_auth_state+1;
	 	}
	 	//驾照认证
	    $rz_driver = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code ="'.$member_code.'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_driver = 0;
	 	}else{
	 	    $sql = ' select dr_auth_state,dr_auth_m_code from bc_driver_auth ';
	 	    $sql.= ' where dr_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $dr_auth_state= $result[0]['dr_auth_state'];
	 	    $rz_driver = (int)$dr_auth_state+1;
	 	}
	 	//公司信息认证
	    $rz_company = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code ="'.$member_code.'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_company = 0;
	 	}else{
	 	    $sql = ' select cy_auth_state,cy_auth_m_code from bc_company_auth ';
	 	    $sql.= ' where cy_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $cy_auth_state= $result[0]['cy_auth_state'];
	 	    $rz_company = (int)$cy_auth_state+1;
	 	}
	     //车型信息认证
	    $rz_cartype = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code ="'.$member_code.'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_cartype = 0;
	 	}else{
	 	    $sql = ' select ct_auth_state,ct_auth_m_code from bc_cartype_auth ';
	 	    $sql.= ' where ct_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ct_auth_state= $result[0]['ct_auth_state'];
	 	    $rz_cartype = (int)$ct_auth_state+1;
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','m_code' => $member_code,'m_name' => $member_name,'m_day' => date('Y-m-d'),'m_token' => $login_log_token,
	 	'm_loc_share' => $member_loc_share,'m_voice_broadcast' => $member_voice_broadcast,'m_sound_reminder' => $member_sound_reminder,
	 	'm_shaking_reminder' => $member_shaking_reminder,'m_receive_info' => $member_receive_info,'m_receive_range' => $member_receive_range
	 	,'m_rz_idcard'=>$rz_idcard,'m_rz_driver'=>$rz_driver,'m_rz_company'=>$rz_company,'m_rz_cartype'=>$rz_cartype
	 	)); 
	 	unset($result,$sql);
	}
    
    function regMemberOne(){//输入手机
        if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	unset($result,$sql);
		//生成验证码
		$code = rand(1000,9999);
		//$_SESSION["code_".$_REQUEST['m_mobile']] = $code;
		//echo $_SESSION["code_".$_REQUEST['m_mobile']];
        $setCon = "验证码：{$code} 有效期为10分钟 【路路帮】";
		$returnResult = setSms($_REQUEST['m_mobile'],$setCon);
		//判断发送是否成功
		$resultResult = explode(',',$returnResult);
		//print_R($resultResult);
		if($resultResult[0] == 1){
			del_m_verifycode_by_mobile($_REQUEST['m_mobile']);
			$inrow = array(
			'm_verifycode_mobile' =>$_REQUEST['m_mobile'],
			'm_verifycode_code' =>$code,
			'm_verifycode_addtime'=>date('Y-m-d H:i:s')
			);
			add_m_verifycode($inrow);
			echo json_encode(array('state' => 0,'err-code' => '')); 
			die();
		}else{
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
    }
	function getCheckCode(){//密码重设第一步 获取验证码
	    if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	//$sql = ' select count(member_code) as cnt from bc_member ';
	 	//$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	//$result = get_info_by_sql($sql);
	 	//$cnt = $result[0]['cnt'];
	 	//if($cnt != 0){
        //    echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	//    die();
	 	//}
	 	unset($result,$sql);
		//生成验证码
		$code = rand(1000,9999);
		//$_SESSION["code_".$_REQUEST['m_mobile']] = $code;
		//echo $_SESSION["code_".$_REQUEST['m_mobile']];
        $setCon = "验证码：{$code} 有效期为10分钟 【路路帮】";
		$returnResult = setSms($_REQUEST['m_mobile'],$setCon);
		//判断发送是否成功
		$resultResult = explode(',',$returnResult);
		//print_R($resultResult);
		if($resultResult[0] == 1){
			del_m_verifycode_by_mobile($_REQUEST['m_mobile']);
			$inrow = array(
			'm_verifycode_mobile' =>$_REQUEST['m_mobile'],
			'm_verifycode_code' =>$code,
			'm_verifycode_addtime'=>date('Y-m-d H:i:s')
			);
			add_m_verifycode($inrow);
			echo json_encode(array('state' => 0,'err-code' => '')); 
			die();
		}else{
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
	}
    //获取验证码
	function getVerifyCode(){
		if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}	
		//$setTel = $this->spArgs('telephone');
		//生成验证码
		$code = rand(1000,9999);
		//$_SESSION['code_'.$_REQUEST['m_mobile']]=$code;
		
		//发送验证码，同时获取返回值
		$setCon = "验证码：{$code} 有效期为10分钟 【路路帮】";
		//echo $setCon,"===",$_REQUEST['m_mobile'];
		
		$returnResult = setSms($_REQUEST['m_mobile'],$setCon);
		
		//判断发送是否成功
		$resultResult = explode(',',$returnResult);
		
		if($resultResult[0] == 1){
			del_m_verifycode_by_mobile($_REQUEST['m_mobile']);
			$inrow = array(
			'm_verifycode_mobile' =>$_REQUEST['m_mobile'],
			'm_verifycode_code' =>$code,
			'm_verifycode_addtime'=>date('Y-m-d H:i:s')
			);
			add_m_verifycode($inrow);
			echo json_encode(array('state' => 0,'err-code' => '')); 
			die();
		}else{
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
	}
	//注册第二步
	function regMemberTwo(){
		if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	unset($result,$sql);
	    if(!$_REQUEST['m_checkcode']){	//验证码 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
	    $cnt = 0;
	 	
	 	$sql = ' select count(m_verifycode_mobile) as cnt from bc_m_verifycode ';
	 	$sql.= ' where m_verifycode_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and m_verifycode_code ="'.$_REQUEST['m_checkcode'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	del_m_verifycode_by_mobile($_REQUEST['m_mobile']); 
	 	del_tmp_mobile_by_mobile($_REQUEST['m_mobile']);
	 	$inrow = array(
			'tm_mobile' =>$_REQUEST['m_mobile'],
			);
		add_tmp_mobile($inrow);
		echo json_encode(array('state' => 0,'err-code' => '')); 
		die();
	}
	function doCheckCode(){//密码重设第二步 验证验证码
		if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	/*$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}*/
	 	unset($result,$sql);
	    if(!$_REQUEST['m_checkcode']){	//验证码 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
	    $cnt = 0;
	 	
	 	$sql = ' select count(m_verifycode_mobile) as cnt from bc_m_verifycode ';
	 	$sql.= ' where m_verifycode_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and m_verifycode_code ="'.$_REQUEST['m_checkcode'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	del_m_verifycode_by_mobile($_REQUEST['m_mobile']); 
	 	del_tmp_mobile_by_mobile($_REQUEST['m_mobile']);
	    $inrow = array(
			'tm_mobile' =>$_REQUEST['m_mobile'],
			);
		add_tmp_mobile($inrow);
		echo json_encode(array('state' => 0,'err-code' => '')); 
		die();
	}
    //注册第三步
	function regMemberThree(){
		if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	unset($result,$sql);
	    $cnt = 0;
	 	$sql = ' select count(tm_mobile) as cnt from bc_tmp_mobile ';
	 	$sql.= ' where tm_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	    die();
	 	}
	    
	    
	    if(!$_REQUEST['m_username']){	//昵称 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x005')); 
			die();
		} 
	    $cnt = 0;
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_name ="'.$_REQUEST['m_username'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('list' => '','state' => 1,'err-code' => 'x006')); 
	 	    	  die();
	 	}
	    if(!$_REQUEST['m_password']){	//密码 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x007')); 
			die();
		}
		
	 	$m_code = substr(md5(date('YmdHis').$_REQUEST['m_mobile']),8,16);
	    $inrow = array(
	 	       'member_code' => $m_code,
	 	       'member_name' => $_REQUEST['m_username'] ,
	 	       'member_md5password' => md5($_REQUEST['m_password']),
	 	       'member_password' => $_REQUEST['m_password'],
	 	       'member_mobile' => $_REQUEST['m_mobile'],
	 	       'member_role' => 0,
	 	       'member_addtime' => date('Y-m-d H:i:s'),
	 	       'member_rmb' => 0,
	 	    );
	 	$result = add_member($inrow);
	 	if(false === $result){
	 	   echo json_encode(array('state' => 1,'err-code' => 'x008')); 
	 	   die();
	 	}
		del_tmp_mobile_by_mobile($_REQUEST['m_mobile']);
	    $row['login_log_c_time'] = date('Y-m-d H:i:s');
	 	$login_log_token = md5(date('YmdHis'));
	 	$row['login_log_token'] = $login_log_token;
	 	$row['login_state'] = 0;
	 	$row['login_mobile'] = $_REQUEST['m_mobile'];
	 	
	 	$row['login_log_time'] = date('Y-m-d H:i:s');
	 	$row['login_log_m_code'] = $m_code;
	 	$row['login_log_day'] = date('Y-m-d'); 
	 	add_login_log($row);
		$sql = ' select member_code,member_name,member_state,
	    member_loc_share,member_voice_broadcast,member_sound_reminder,member_shaking_reminder
	    ,member_receive_info,member_receive_range
	      from bc_member ';
	 	$sql.= ' where member_code ="'.$m_code.'"';
	 	$result = get_info_by_sql($sql);
	 	
	 	
	 	$member_loc_share = $result[0]['member_loc_share'];
	 	$member_voice_broadcast = $result[0]['member_voice_broadcast'];
	 	$member_sound_reminder = $result[0]['member_sound_reminder'];
	 	$member_shaking_reminder = $result[0]['member_shaking_reminder'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	
	 	unset($result,$sql);
		//$_SESSION['vc_'.$_REQUEST['m_mobile']] = null;
		echo json_encode(array('state' => 0,'err-code' => '','m_code'=>$m_code,'m_token'=>$login_log_token,
	 	'm_loc_share' => $member_loc_share,'m_voice_broadcast' => $member_voice_broadcast,'m_sound_reminder' => $member_sound_reminder,
	 	'm_shaking_reminder' => $member_shaking_reminder,'m_receive_info' => $member_receive_info,'m_receive_range' => $member_receive_range)); 
		die();
	}
	
    function doUpPassword(){//密码重设第三步 保存设置的密码
        if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		
	    $cnt = 0;
	 	$sql = ' select count(tm_mobile) as cnt from bc_tmp_mobile ';
	 	$sql.= ' where tm_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	    die();
	 	}
	    if(!$_REQUEST['m_password']){	//密码 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x007')); 
			die();
		}
		$inrow = array(
	 	       'member_md5password' => md5($_REQUEST['m_password']),
	 	       'member_password' => $_REQUEST['m_password'],
	 	    );
		$result = update_member_by_mobile($_REQUEST['m_mobile'],$inrow);
	 	if(false === $result){
	 	   echo json_encode(array('state' => 1,'err-code' => 'x008')); 
	 	   die();
	 	}
		del_tmp_mobile_by_mobile($_REQUEST['m_mobile']);
		echo json_encode(array('state' => 0,'err-code' => '')); 
		die();
		
    }
    
    //自动登录
	function loginBySelf(){
	 	// 密码不正确
	 	$cnt = 0;
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and member_md5password = "'.md5($_REQUEST['m_pwd']).'"';
	 	$sql.= ' and member_state = 0 ';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
	 	    	  die();
	 	}
	 	unset($result,$sql);
	 	$uprow =array(
	 	    'member_latitudee6'=>$_REQUEST['m_latitudee6'],
	 	    'member_longitudee6'=>$_REQUEST['m_longitudee6'],
	 	    );
	 	//今天是否登录过
	 	$cnt = 0;
	 	$sql = ' select count(login_log_id) as cnt from bc_login_log ';
	 	$sql.= ' where login_log_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and login_log_day = "'.date('Y-m-d').'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$row['login_log_c_time'] = date('Y-m-d H:i:s');
	 	$login_log_token = md5(date('YmdHis'));
	 	//    $login_log_token =  $_REQUEST['m_code'].'--'.date('YmdHis');
	 	$row['login_log_token'] = $login_log_token;
	 	$row['login_state'] = 0;
	 	$row['login_mobile'] = $_REQUEST['m_mobile'];
	 	if($cnt == 0){
	 	    $row['login_log_time'] = date('Y-m-d H:i:s');
	 	    $row['login_log_m_code'] = $_REQUEST['m_code'];
	 	    $row['login_log_day'] = date('Y-m-d'); 
	 	    $result = add_login_log($row);
	 	    if(false === $result){
	 	        echo json_encode(array('state' => 1,'err-code' => 'x001'));
	 	    	die();
	 	    }
	 	    update_member($_REQUEST['m_code'],$uprow);
	 	}else{
	 	    $result = update_login_log($_REQUEST['m_code'],date('Y-m-d'),$row);
	 	    if(false === $result){
	 	    	echo json_encode(array('state' => 1,'err-code' => 'x001')); 
	 	    	die();
	 	    }
	 	    update_member($_REQUEST['m_code'],$uprow);
	 	}
	 	
	 	$sql = ' select member_code,member_name,member_state,
	    member_loc_share,member_voice_broadcast,member_sound_reminder,member_shaking_reminder
	    ,member_receive_info,member_receive_range
	      from bc_member ';
	 	$sql.= ' where member_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	
	 	
	 	$member_loc_share = $result[0]['member_loc_share'];
	 	$member_voice_broadcast = $result[0]['member_voice_broadcast'];
	 	$member_sound_reminder = $result[0]['member_sound_reminder'];
	 	$member_shaking_reminder = $result[0]['member_shaking_reminder'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	
	 	unset($result,$sql);
	    //身份认证
		$rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_idcard = 0;
	 	}else{
	 	    $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ic_auth_state= $result[0]['ic_auth_state'];
	 	    $rz_idcard = (int)$ic_auth_state+1;
	 	}
	 	//驾照认证
	    $rz_driver = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_driver = 0;
	 	}else{
	 	    $sql = ' select dr_auth_state,dr_auth_m_code from bc_driver_auth ';
	 	    $sql.= ' where dr_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $dr_auth_state= $result[0]['dr_auth_state'];
	 	    $rz_driver = (int)$dr_auth_state+1;
	 	}
	 	//公司信息认证
	    $rz_company = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_company = 0;
	 	}else{
	 	    $sql = ' select cy_auth_state,cy_auth_m_code from bc_company_auth ';
	 	    $sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $cy_auth_state= $result[0]['cy_auth_state'];
	 	    $rz_company = (int)$cy_auth_state+1;
	 	}
	     //车型信息认证
	    $rz_cartype = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_cartype = 0;
	 	}else{
	 	    $sql = ' select ct_auth_state,ct_auth_m_code from bc_cartype_auth ';
	 	    $sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ct_auth_state= $result[0]['ct_auth_state'];
	 	    $rz_cartype = (int)$ct_auth_state+1;
	 	}
	 	
	 	
	    echo json_encode(array('state' => 0,'err-code' => '','m_code' => $_REQUEST['m_code'],'m_day' => date('Y-m-d'),'m_token' => $login_log_token,
	 	'm_loc_share' => $member_loc_share,'m_voice_broadcast' => $member_voice_broadcast,'m_sound_reminder' => $member_sound_reminder,
	 	'm_shaking_reminder' => $member_shaking_reminder,'m_receive_info' => $member_receive_info,'m_receive_range' => $member_receive_range
	    ,'m_rz_idcard'=>$rz_idcard,'m_rz_driver'=>$rz_driver,'m_rz_company'=>$rz_company,'m_rz_cartype'=>$rz_cartype)); 
	 	unset($result,$sql);
	}
    //自动连接
	function linkBySelf(){
	 	//token 一样否
	 	$cnt = 0;
	 	$sql = ' select count(login_log_id) as cnt from bc_login_log ';
	 	$sql.= ' where login_log_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and login_log_token ="'.$_REQUEST['m_token'].'"';
	 	$sql.= ' and login_log_day = "'.date('Y-m-d').'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){//被别人登出了
            echo json_encode(array('state' => 1,'err-code' => 'x002'));
	 	    die();
	 	}
	 	unset($result,$sql);
	 	$uprow =array(
	 	    'member_latitudee6'=>$_REQUEST['m_latitudee6'],
	 	    'member_longitudee6'=>$_REQUEST['m_longitudee6'],
	 	    );
	 	
	 	
	 	$row['login_log_c_time'] = date('Y-m-d H:i:s');
	 	$row['login_state'] = 0;
	 	$result = update_login_log($_REQUEST['m_code'],date('Y-m-d'),$row);
	 	if(false === $result){
	 	   echo json_encode(array('state' => 1,'err-code' => 'x001')); 
	 	   die();
	 	}
	 	update_member($_REQUEST['m_code'],$uprow);
	 	
	 	$sql = ' select member_code,member_name,member_state,
	    member_loc_share,member_voice_broadcast,member_sound_reminder,member_shaking_reminder
	    ,member_receive_info,member_receive_range
	      from bc_member ';
	 	$sql.= ' where member_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	
	 	$member_loc_share = $result[0]['member_loc_share'];
	 	$member_voice_broadcast = $result[0]['member_voice_broadcast'];
	 	$member_sound_reminder = $result[0]['member_sound_reminder'];
	 	$member_shaking_reminder = $result[0]['member_shaking_reminder'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	
	 	unset($result,$sql);
	//身份认证
		$rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_idcard = 0;
	 	}else{
	 	    $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ic_auth_state= $result[0]['ic_auth_state'];
	 	    $rz_idcard = (int)$ic_auth_state+1;
	 	}
	 	//驾照认证
	    $rz_driver = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_driver = 0;
	 	}else{
	 	    $sql = ' select dr_auth_state,dr_auth_m_code from bc_driver_auth ';
	 	    $sql.= ' where dr_auth_m_code ="'.$member_code.'"';
	 	    $result = get_info_by_sql($sql);
	 	    $dr_auth_state= $result[0]['dr_auth_state'];
	 	    $rz_driver = (int)$dr_auth_state+1;
	 	}
	 	//公司信息认证
	    $rz_company = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_company = 0;
	 	}else{
	 	    $sql = ' select cy_auth_state,cy_auth_m_code from bc_company_auth ';
	 	    $sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $cy_auth_state= $result[0]['cy_auth_state'];
	 	    $rz_company = (int)$cy_auth_state+1;
	 	}
	     //车型信息认证
	    $rz_cartype = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_cartype = 0;
	 	}else{
	 	    $sql = ' select ct_auth_state,ct_auth_m_code from bc_cartype_auth ';
	 	    $sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ct_auth_state= $result[0]['ct_auth_state'];
	 	    $rz_cartype = (int)$ct_auth_state+1;
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','m_code' => $_REQUEST['m_code'],'m_day' => date('Y-m-d'),'m_token' => $_REQUEST['m_token'],
	 	'm_loc_share' => $member_loc_share,'m_voice_broadcast' => $member_voice_broadcast,'m_sound_reminder' => $member_sound_reminder,
	 	'm_shaking_reminder' => $member_shaking_reminder,'m_receive_info' => $member_receive_info,'m_receive_range' => $member_receive_range
	 	,'m_rz_idcard'=>$rz_idcard,'m_rz_driver'=>$rz_driver,'m_rz_company'=>$rz_company,'m_rz_cartype'=>$rz_cartype)); 
	 	unset($result,$sql);
	 }
    
	//会员信息
	function setAccount(){
		$uprow['member_sex'] = $_REQUEST['m_sex'];
		$uprow['member_birthday'] = $_REQUEST['m_birthday'];
		$uprow['member_jz_date'] = $_REQUEST['m_driver_time'];
		$uprow['member_profession'] = $_REQUEST['m_profession'];
		$uprow['member_marital_status'] = $_REQUEST['m_marital_status'];
		$uprow['member_school'] = $_REQUEST['m_school'];
		$uprow['member_signature'] = $_REQUEST['m_sign'];
		
		$uprow['member_about'] = $_REQUEST['m_gr_about'];
		$uprow['member_realname'] = $_REQUEST['m_realname'];
		$uprow['member_cardcode'] = $_REQUEST['m_idcard'];
		$uprow['member_company'] = $_REQUEST['m_company'];
		$uprow['member_jz_type'] = $_REQUEST['m_driver_type'];
		$uprow['member_jz_code'] = $_REQUEST['m_driver_code'];
		$uprow['member_car_type'] = $_REQUEST['m_driver_car'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	 die();
	}
    //获取会员信息
	function getMember(){
		//身份认证
		$rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_idcard = 0;
	 	}else{
	 	    $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ic_auth_state= $result[0]['ic_auth_state'];
	 	    $rz_idcard = (int)$ic_auth_state+1;
	 	}
	 	//驾照认证
	    $rz_driver = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_driver = 0;
	 	}else{
	 	    $sql = ' select dr_auth_state,dr_auth_m_code from bc_driver_auth ';
	 	    $sql.= ' where dr_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $dr_auth_state= $result[0]['dr_auth_state'];
	 	    $rz_driver = (int)$dr_auth_state+1;
	 	}
	 	//公司信息认证
	    $rz_company = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_company = 0;
	 	}else{
	 	    $sql = ' select cy_auth_state,cy_auth_m_code from bc_company_auth ';
	 	    $sql.= ' where cy_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $cy_auth_state= $result[0]['cy_auth_state'];
	 	    $rz_company = (int)$cy_auth_state+1;
	 	}
	     //车型信息认证
	    $rz_cartype = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_cartype = 0;
	 	}else{
	 	    $sql = ' select ct_auth_state,ct_auth_m_code from bc_cartype_auth ';
	 	    $sql.= ' where ct_auth_m_code ="'.$_REQUEST['m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ct_auth_state= $result[0]['ct_auth_state'];
	 	    $rz_cartype = (int)$ct_auth_state+1;
	 	}
	 	//店铺地址信息
	 	$shop_address = '';
	 	$sql = ' select sa_m_code,sa_address from bc_shop_address ';
	 	$sql.= ' where sa_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$shop_address = $result[0]['sa_address'];
	 	if($shop_address == null)$shop_address = '';
	 	
		
	 	$sql = ' select member_logo,member_name,member_mobile,member_type,member_role,
	 	member_rmb,member_birthday,member_sex,member_signature,member_profession,member_marital_status,
	 	member_school,member_about, member_realname,member_cardcode,member_company,
	 	member_jz_type,member_jz_date,member_car_type,
	 	member_loc_share,member_voice_broadcast,member_sound_reminder,member_shaking_reminder,
	 	member_receive_info,member_receive_range  from bc_member ';
        $sql.= ' where member_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('m_name' => $result[0]['member_name'],'m_mobile' => $result[0]['member_mobile'],'m_logo' => $result[0]['member_logo'],
	 	   'm_type' => $result[0]['member_type'],'m_rmb' => $result[0]['member_rmb'],'m_role' => $result[0]['member_role'],
	 	   'm_birthday' => $result[0]['member_birthday'],'m_sex' => $result[0]['member_sex'],'m_signature' => $result[0]['member_signature'],
	 	   'm_profession' => $result[0]['member_profession'],'m_marital_status' => $result[0]['member_marital_status'],'m_school' => $result[0]['member_school'],
	 	   'm_about' => $result[0]['member_about'],'m_realname' => $result[0]['member_realname'],'m_cardcode' => $result[0]['member_cardcode'],
	 	   'm_company' => $result[0]['member_company'],'m_jz_type' => $result[0]['member_jz_type'],'m_jz_date' => $result[0]['member_jz_date'],
	 	   'm_car_type' => $result[0]['member_car_type'],'m_rz_idcard'=>$rz_idcard,'m_rz_driver'=>$rz_driver,'m_rz_company'=>$rz_company,
	 	'm_rz_cartype'=>$rz_cartype,
	 	   'm_shop_address' => $shop_address,'state' => 0,'err-code' => ''));
	}
    function getMemberOther(){
    	//店铺地址信息
	 	$shop_address = '';
	 	$sql = ' select sa_m_code,sa_address from bc_shop_address ';
	 	$sql.= ' where sa_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$shop_address = $result[0]['sa_address'];
	 	if($shop_address == null)$shop_address = '';
	 	unset($sql,$result);
        $sql = ' select member_sale_area,member_company_web from bc_member ';
        $sql.= ' where member_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
    	echo json_encode(array('m_sale_area' => $result[0]['member_sale_area'],'m_shop_address' => $shop_address,
    	'm_company_web' => $result[0]['member_company_web'],'state' => 0,'err-code' => ''));
        die();
    }
    function setSaleArea(){
    	$uprow['member_sale_area'] = $_REQUEST['sale_area'];
	 	//$uprow['member_md5password'] = md5($_REQUEST['m_password']);
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
    }
    function setCompanyWeb(){
    	$uprow['member_company_web'] = $_REQUEST['company_web'];
	 	//$uprow['member_md5password'] = md5($_REQUEST['m_password']);
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
    }
    //会员头像上传接口
	function upMLogo(){
	 	if (empty($_FILES) === true){
	 	   	 echo 'err'; 
	 	   	 die();
	 	} 
	 	//文件保存目录路径
        $save_path = APP_PATH.'/files/m_logo/';
        //原文件名
	    $file_name = $_FILES['mlogo']['name'];
	    //服务器上临时文件名
	    $tmp_name = $_FILES['mlogo']['tmp_name'];
	    $temp_arr = explode('.', $file_name);
		$file_ext = array_pop($temp_arr);
		$file_ext = trim($file_ext);
		$file_ext = strtolower($file_ext);
		//$new_name =$_REQUEST['mId'].date("YmdHis").'.'.$file_ext;
		//$new_name =$_REQUEST['m_code'].date("YmdHis").'.'.$file_ext;
	    $file_path = $save_path.$file_name;
	    if (move_uploaded_file($tmp_name, $file_path) === false){
	     	 echo 'err'; 
	         die();
	    }
	    
	    $uprow['member_logo'] = $file_name;
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo 'err'; 
	 	    	 die();
	 	 }
	 	 //if($_REQUEST['m_o_logo'] !="")unlink($save_path.$_REQUEST['m_o_logo']);
	 	 echo 'ok'; 
	}
	
    //修改昵称接口
	function setUserName(){
	    if(!$_REQUEST['m_name']){	//参数m_name 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_name ="'.$_REQUEST['m_name'].'"';
	 	$sql.= ' and member_code <> "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	$uprow['member_name'] = $_REQUEST['m_name'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	 die();
	}
    //修改密码接口
	function setPassword(){
	    if(!$_REQUEST['m_password']){	//参数m_name 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    
	 	$uprow['member_password'] = $_REQUEST['m_password'];
	 	$uprow['member_md5password'] = md5($_REQUEST['m_password']);
	    $uprow['member_pwd_date'] = date('Y-m-d');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
	}
    //修改性别接口
	function setSex(){
	    if(!isset($_REQUEST['m_sex'])){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(isset($_REQUEST['m_sex']) and ($_REQUEST['m_sex'] == '')){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    
	 	$uprow['member_sex'] = (int)$_REQUEST['m_sex'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
	}
	//修改职业接口
    function setProfession(){
	    if(!$_REQUEST['m_profession']){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	 	$uprow['member_profession'] = $_REQUEST['m_profession'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
	}
    //修改婚姻接口
    function setMaritalStatus(){
    	if(!isset($_REQUEST['m_marital_status'])){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(isset($_REQUEST['m_marital_status']) and ($_REQUEST['m_marital_status'] == '')){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    
	 	$uprow['member_marital_status'] = (int)$_REQUEST['m_marital_status'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	 	die();
    }
    //修改个性签名接口
    function setSignature(){
	    if(!$_REQUEST['m_signature']){	//参数m_signature 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	 	$uprow['member_signature'] = $_REQUEST['m_signature'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
    //修改个人说明接口
    function setGRAbout(){
	    if(!$_REQUEST['m_about']){	//参数m_about 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	 	$uprow['member_about'] = $_REQUEST['m_about'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
    //修改学校接口
    function setSchool(){
    	if(!$_REQUEST['m_school']){	//参数m_about 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	 	$uprow['member_school'] = $_REQUEST['m_school'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
	//修改出生日期接口
    function setBirthday(){
    	if(!$_REQUEST['m_birthday']){	//参数m_about 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	 	$uprow['member_birthday'] = date('Y-m-d',strtotime($_REQUEST['m_birthday']));
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
    
    //修改手机号接口one
    function setMobileOne(){
        if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and member_code <> "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	unset($result,$sql);
		//生成验证码
		$code = rand(1000,9999);
		//$_SESSION["code_".$_REQUEST['m_mobile']] = $code;
		//echo $_SESSION["code_".$_REQUEST['m_mobile']];
        $setCon = "验证码：{$code} 有效期为10分钟 【路路帮】";
		$returnResult = setSms($_REQUEST['m_mobile'],$setCon);
		//判断发送是否成功
		$resultResult = explode(',',$returnResult);
		//print_R($resultResult);
		if($resultResult[0] == 1){
			del_m_verifycode_by_mobile($_REQUEST['m_mobile']);
			$inrow = array(
			'm_verifycode_mobile' =>$_REQUEST['m_mobile'],
			'm_verifycode_code' =>$code,
			'm_verifycode_addtime'=>date('Y-m-d H:i:s')
			);
			add_m_verifycode($inrow);
			echo json_encode(array('state' => 0,'err-code' => '')); 
			die();
		}else{
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
    }
    
    //修改手机号接口two
    function setMobileTwo(){
    	if(!$_REQUEST['m_mobile']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and member_code <> "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	unset($result,$sql);
	    if(!$_REQUEST['m_checkcode']){	//验证码 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
	    $cnt = 0;
	 	
	 	$sql = ' select count(m_verifycode_mobile) as cnt from bc_m_verifycode ';
	 	$sql.= ' where m_verifycode_mobile ="'.$_REQUEST['m_mobile'].'"';
	 	$sql.= ' and m_verifycode_code ="'.$_REQUEST['m_checkcode'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt == 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	del_m_verifycode_by_mobile($_REQUEST['m_mobile']); 
	 	$uprow['member_mobile'] = $_REQUEST['m_mobile'];
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
		die();
    }
    
    //设置会员为商家
    function setProvider(){
    	$uprow['member_role'] = 1;
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
		die();
    }
    
    //会员上传图片接口
	function upMap(){
	 	if (empty($_FILES) === true){
	 	   	 echo 'err'; 
	 	   	 die();
	 	} 
	 	//文件保存目录路径
        $save_path = APP_PATH.'/files/map/';
        //原文件名
	    $file_name = $_FILES['m_map']['name'];
	    //服务器上临时文件名
	    $tmp_name = $_FILES['m_map']['tmp_name'];
	    $temp_arr = explode('.', $file_name);
		$file_ext = array_pop($temp_arr);
		$file_ext = trim($file_ext);
		$file_ext = strtolower($file_ext);
		//$new_name =$_REQUEST['mId'].date("YmdHis").'.'.$file_ext;
		//$new_name =$_REQUEST['m_code'].date("YmdHis").'.'.$file_ext;
	    $file_path = $save_path.$file_name;
	    if (move_uploaded_file($tmp_name, $file_path) === false){
	     	 echo 'err'; 
	         die();
	    }
	    /*
	     $uprow['member_logo'] = $file_name;
	     $uprow['member_uptime'] = date('Y-m-d H:i:s');
	     $result = update_member($_REQUEST['m_code'],$uprow);
	     if(false === $result){
	 	    	 echo 'err'; 
	 	    	 die();
	 	 }*/
	 	//if($_REQUEST['m_o_icmap'] !="")unlink($save_path.$_REQUEST['m_o_icmap']);
	 	echo 'ok'; 
	}
    //设置身份认证信息
	function setApplyIdCard(){
	    if(!$_REQUEST['m_realname']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(!$_REQUEST['m_idcard_code']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    if(!$_REQUEST['m_idcard_map']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
		$cnt = 0;
	 	//shouji  1002 已经存在
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$inrow =array(
	 	'ic_auth_realname'=>$_REQUEST['m_realname'],
	 	'ic_auth_cardcode'=>$_REQUEST['m_idcard_code'],
	 	'ic_auth_map'=>$_REQUEST['m_idcard_map'],
	 	);
	 	if($cnt != 0){
	 		$inrow['ic_auth_state']= 0;
	 		$inrow['ic_auth_uptime']= date('Y-m-d H:i:s');
	 		$result = update_idcard_auth($_REQUEST['m_code'],$inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}else{
	 		$inrow['ic_auth_m_code']= $_REQUEST['m_code'];
	 		$inrow['ic_auth_state']= 0;
	 		$inrow['ic_auth_addtime']= date('Y-m-d H:i:s');
	 		$result = add_idcard_auth($inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	unset($result,$sql);
	}
    //取得身份认证信息
    function getApplyIdCard(){
    	$sql = ' select ic_auth_m_code,ic_auth_realname,ic_auth_cardcode,ic_auth_map,ic_auth_state from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$ic_auth_realname = $result[0]['ic_auth_realname'];
	 	$ic_auth_cardcode = $result[0]['ic_auth_cardcode'];
	 	$ic_auth_map = $result[0]['ic_auth_map'];
	 	//$ic_auth_state = $result[0]['ic_auth_state'];
	 	echo json_encode(array('state' => 0,'err-code' => '','m_realname'=>$ic_auth_realname,'m_cardcode'=>$ic_auth_cardcode,'m_map'=>$ic_auth_map));
	 	unset($result,$sql);
    }
	//取得驾照认证信息
	function getApplyDriver(){
		$sql = ' select dr_auth_m_code,dr_auth_type,dr_auth_code,dr_auth_car_type,dr_auth_fz_addtime,dr_auth_map 
		  from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$dr_auth_type = $result[0]['dr_auth_type'];
	 	$dr_auth_code = $result[0]['dr_auth_code'];
	 	$dr_auth_car_type = $result[0]['dr_auth_car_type'];
	 	$dr_auth_fz_addtime = $result[0]['dr_auth_fz_addtime'];
	 	$dr_auth_map = $result[0]['dr_auth_map'];
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','m_dr_type'=>$dr_auth_type,'m_dr_code'=>$dr_auth_code,
	 	'm_car_type'=>$dr_auth_car_type,'m_fz_addtime'=>$dr_auth_fz_addtime,'m_dr_map'=>$dr_auth_map));
	 	unset($result,$sql);
	}
	//设置驾照认证信息
	function setApplyDriver(){
	    if(!$_REQUEST['m_dr_type']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(!$_REQUEST['m_dr_code']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    //if(!$_REQUEST['m_car_type']){	//参数手机号 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x004')); 
		//	die();
		//}
	    if(!$_REQUEST['m_fz_addtime']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			die();
		}
		//shouji  1002 已经存在
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$inrow =array(
	 	'dr_auth_type'=>$_REQUEST['m_dr_type'],
	 	'dr_auth_code'=>$_REQUEST['m_dr_code'],
	 	'dr_auth_fz_addtime'=>date('Y-m-d',strtotime($_REQUEST['m_fz_addtime'])),
	 	'dr_auth_map'=>$_REQUEST['m_dr_map'],
	 	);
	 	//if($_REQUEST['m_car_type'])$inrow['dr_auth_car_type']= $_REQUEST['m_car_type'];
	 	if($cnt != 0){
	 		$inrow['dr_auth_state']= 0;
	 		$inrow['dr_auth_uptime']= date('Y-m-d H:i:s');
	 		$result = update_driver_auth($_REQUEST['m_code'],$inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}else{
	 		$inrow['dr_auth_m_code']= $_REQUEST['m_code'];
	 		$inrow['dr_auth_state']= 0;
	 		$inrow['dr_auth_addtime']= date('Y-m-d H:i:s');
	 		$result = add_driver_auth($inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	unset($result,$sql);		
	}
    //取得认证信息
	function getApplyCarType(){
		$sql = ' select member_code,member_car_type  from bc_member  ';
	 	$sql.= ' where member_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
		$member_car_type = $result[0]['member_car_type'];
	 	unset($result,$sql);
		$sql = ' select ct_auth_m_code,ct_auth_carttype,ct_auth_cbz_map,ct_auth_xsz_map,ct_auth_fapiao_map
		  from bc_cartype_auth  ';
	 	$sql.= ' where ct_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$ct_auth_carttype = $result[0]['ct_auth_carttype'];
	 	if($ct_auth_carttype == "")$ct_auth_carttype =$member_car_type;
	 	$ct_auth_cbz_map = $result[0]['ct_auth_cbz_map'];
	 	$ct_auth_xsz_map = $result[0]['ct_auth_xsz_map'];
	 	$ct_auth_fapiao_map = $result[0]['ct_auth_fapiao_map'];
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','m_car_type'=>$ct_auth_carttype,'m_cbz_map'=>$ct_auth_cbz_map
	 	,'m_xsz_map'=>$ct_auth_xsz_map,'m_fp_map'=>$ct_auth_fapiao_map));
	 	unset($result,$sql);
	}
	function setApplyCarType(){
		if(!$_REQUEST['m_cartype']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		//shouji  1002 已经存在
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$inrow =array(
	 	'ct_auth_carttype'=>$_REQUEST['m_cartype'],
	 	'ct_auth_cbz_map'=>$_REQUEST['m_cpz_map'],
	 	'ct_auth_xsz_map'=>$_REQUEST['m_xsz_map'],
	 	'ct_auth_fapiao_map'=>$_REQUEST['m_fap_map'],
	 	);
	 	if($cnt != 0){
	 		$inrow['ct_auth_state']= 0;
	 		$inrow['ct_auth_uptime']= date('Y-m-d H:i:s');
	 		$result = update_cartype_auth($_REQUEST['m_code'],$inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}else{
	 		$inrow['ct_auth_m_code']= $_REQUEST['m_code'];
	 		$inrow['ct_auth_state']= 0;
	 		$inrow['ct_auth_addtime']= date('Y-m-d H:i:s');
	 		$result = add_cartype_auth($inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	unset($result,$sql);
	}
	//取得公司认证信息
	function getApplyCompany(){
		$sql = ' select cy_auth_m_code,cy_auth_company,cy_auth_map,cy_auth_cpy_type,cy_auth_address  from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cy_auth_company = $result[0]['cy_auth_company'];
	 	$cy_auth_map = $result[0]['cy_auth_map'];
	 	$cy_auth_cpy_type = $result[0]['cy_auth_cpy_type'];
	 	$cy_auth_address = $result[0]['cy_auth_address'];
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','m_cy_company'=>$cy_auth_company,'m_cy_map'=>$cy_auth_map
	 	,'m_cy_cpy_type'=>$cy_auth_cpy_type,'m_cy_address'=>$cy_auth_address));
	 	unset($result,$sql);
	}
	//取得公司认证信息
	function setApplyCompany(){
		if(!$_REQUEST['m_cy_company']){	//参数手机号 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		//shouji  1002 已经存在
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	$inrow =array(
	 	'cy_auth_company'=>$_REQUEST['m_cy_company'],
	 	'cy_auth_map'=>$_REQUEST['m_cy_map'],
	 	'cy_auth_cpy_type'=>$_REQUEST['m_cy_company_type'],
	 	'cy_auth_address'=>$_REQUEST['m_cy_company_address'],
	 	);
	 	if($cnt != 0){
	 		$inrow['cy_auth_state']= 0;
	 		$inrow['cy_auth_uptime']= date('Y-m-d H:i:s');
	 		$result = update_company_auth($_REQUEST['m_code'],$inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}else{
	 		$inrow['cy_auth_m_code']= $_REQUEST['m_code'];
	 		$inrow['cy_auth_state']= 0;
	 		$inrow['cy_auth_addtime']= date('Y-m-d H:i:s');
	 		$result = add_company_auth($inrow);
	 	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	unset($result,$sql);
	}
	
    //修改店铺地址接口
	function setShopAddress(){
	    if(!$_REQUEST['m_shop_address']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(sa_m_code) as cnt from bc_shop_address ';
	 	$sql.= ' where sa_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
	 	    $uprow['sa_address'] = $_REQUEST['m_shop_address'];
	 	    $uprow['sa_latitudee6'] = $_REQUEST['sa_latitudee6'];
	 	    $uprow['sa_longitudee6'] = $_REQUEST['sa_longitudee6'];
	        $uprow['sa_uptime'] = date('Y-m-d H:i:s');
	        $result = update_shop_address($_REQUEST['m_code'],$uprow);
	        if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}else{
	 		$sa_id = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 		$inrow = array(
	 		'sa_id'=> $sa_id,
	 		'sa_m_code'=> $_REQUEST['m_code'],
	 		'sa_address'=> $_REQUEST['m_shop_address'],
	 		'sa_latitudee6'=> $_REQUEST['sa_latitudee6'],
	 		'sa_longitudee6'=> $_REQUEST['sa_longitudee6'],
	 		'sa_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	    $result = add_shop_address($inrow);
	        if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	    }
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//添加区域分类接口
	function addAddressType(){
	    if(!$_REQUEST['m_addresstype_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(at_id) as cnt from bc_address_type ';
	 	$sql.= ' where at_name ="'.$_REQUEST['m_addresstype_name'].'"';
	 	$sql.= ' and at_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	$str_ops = split(",", $_REQUEST['m_geopoint']);
	 	$at_id = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$inrow = array(
	 		'at_id'=> $at_id,
	 		'at_m_code'=> $_REQUEST['m_code'],
	 		'at_name'=> $_REQUEST['m_addresstype_name'],
	 	 'at_type'=> $_REQUEST['m_at_type'],
	 	    'at_address_xz'=> $_REQUEST['m_address_xz'],
	 	    'at_address_hf'=> $_REQUEST['m_address_hf'],
	 	    'at_address_hf_ds'=> $_REQUEST['m_address_hf_ds'],
	 	    'at_dd_address'=> $_REQUEST['m_address'],
	 	  'at_latitudee6'=> (int)$str_ops[0],
	 	  'at_longitudee6'=> (int)$str_ops[1],
	 	    'at_distance'=> (int)$_REQUEST['m_distance'],
	 		'at_addtime'=> date('Y-m-d H:i:s'),
	 	);
	    $result = add_address_type($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//编辑区域分类接口
	function editAddressType(){
	    if(!$_REQUEST['m_addresstype_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(at_id) as cnt from bc_address_type ';
	 	$sql.= ' where at_name ="'.$_REQUEST['m_addresstype_name'].'"';
	 	$sql.= ' and at_id <> "'.$_REQUEST['at_id'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	$str_ops = split(",", $_REQUEST['m_geopoint']);
	 	$uprow = array(
	 		'at_m_code'=> $_REQUEST['m_code'],
	 		'at_name'=> $_REQUEST['m_addresstype_name'],
	 	    'at_address_xz'=> $_REQUEST['m_address_xz'],
	 	    'at_address_hf'=> $_REQUEST['m_address_hf'],
	 	     'at_address_hf_ds'=> $_REQUEST['m_address_hf_ds'],
	 	     'at_dd_address'=> $_REQUEST['m_address'],
	 	  'at_latitudee6'=> (int)$str_ops[0],
	 	  'at_longitudee6'=> (int)$str_ops[1],
	 	    'at_distance'=> (int)$_REQUEST['m_distance'],
	 		'at_uptime'=> date('Y-m-d H:i:s'),
	 	);
	    $result = update_address_type($_REQUEST['at_id'],$uprow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//获取区域分类接口
	function getAddressTypeForEdit(){
	    if(!$_REQUEST['at_id']){	//参数at_id 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$sql = ' select at_id,at_name,at_address_xz,at_address_hf,at_distance,
at_dd_address,at_latitudee6,at_longitudee6,at_type,at_address_hf_ds
		from bc_address_type ';
	 	$sql.= ' where at_id ="'.$_REQUEST['at_id'].'"';
	 	//$sql.= ' and at_id = '.$_REQUEST['at_id'];
	 	$result = get_info_by_sql($sql);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','at_type' => $result[0]['at_type'],'at_name' => $result[0]['at_name']
	 	,'at_address_xz' => $result[0]['at_address_xz'],'at_address_hf' => $result[0]['at_address_hf'],
	 	'at_dd_address' => $result[0]['at_dd_address'],'at_distance' => $result[0]['at_distance'],
	 	'at_latitudee6' => $result[0]['at_latitudee6'],'at_longitudee6' => $result[0]['at_longitudee6']
	 	,'at_address_hf_ds' => $result[0]['at_address_hf_ds']
	 	));
	 	die();
	}
	
	//获取区域分类列表接口
	function getAddressTypeList(){
		$sql = ' select at_id,at_name from bc_address_type ';
	 	$sql.= ' where at_m_code = "'.$_REQUEST['m_code'].'" and at_isdel=0 ';
	 	$result = get_info_by_sql($sql);
	 	//if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//删除区域分类列表接口
	function delAddressType(){
	    if(!$_REQUEST['at_id']){	//参数at_id 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$uprow = array(
	 		'at_isdel'=> 1,
	 		'at_uptime'=> date('Y-m-d H:i:s'),
	 	);
	    $result = update_address_type($_REQUEST['at_id'],$uprow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
    //发布拼车服务商品
    function addSPPinche(){
        if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
        //if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
	    //if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	
        $uprow['member_role'] = 1;
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	
		$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$inrow = array(
	 		'sproduct_code'=> $sproduct_code,
	 		'sproduct_m_code'=> $_REQUEST['m_code'],
	 	    'sproduct_state'=> 1,
	 	    'sproduct_type'=> 1,
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    //'sproduct_p_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	
	 	    'sproduct_pc_price_set'=> (int)$_REQUEST['m_sp_price_set'],
	 	'sproduct_pc_price_one'=> $_REQUEST['m_sp_price_one'],
	 	'sproduct_pc_price_bc'=> $_REQUEST['m_sp_price_bc'],
	 	'sproduct_pc_price_two'=> $_REQUEST['m_sp_price_two'],
	 	//'sproduct_pc_price_two_bc'=> $_REQUEST['m_sp_price_two_bc'],
	 	'sproduct_pc_price_three'=> $_REQUEST['m_sp_price_three'],
	 	//'sproduct_pc_price_three_bc'=> $_REQUEST['m_sp_price_three_bc'],
	 	'sproduct_pc_price_four'=> $_REQUEST['m_sp_price_four'],
	 	//'sproduct_pc_price_four_bc'=> $_REQUEST['m_sp_price_four_bc'],
	 	
	 	//'sproduct_pc_price_f_t'=> $_REQUEST['m_sp_price_f_t'],
	 	//'sproduct_pc_price_f_t_bc'=> $_REQUEST['m_sp_price_f_t_bc'],
	 	//'sproduct_pc_price_tmore'=> $_REQUEST['m_sp_price_tmore'],
	 	//'sproduct_pc_price_tmore_bc'=> $_REQUEST['m_sp_price_tmore_bc'],
	 	);
	 	$result = add_service_product($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	if(isset($_REQUEST['m_sp_vip']) and ($_REQUEST['m_sp_vip'] == 1)){
	 	$inrow2 = array(
	 		'vip_apply_sp_code'=> $sproduct_code,
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = add_vip_sproduct_apply($inrow2);
	 	}
        //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
	
     //发布带货服务商品
    function addSPDaihuo(){
        if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
       // if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
	   // if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	
    $uprow['member_role'] = 1;
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	} 
		$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$inrow = array(
	 		'sproduct_code'=> $sproduct_code,
	 		'sproduct_m_code'=> $_REQUEST['m_code'],
	 	    'sproduct_state'=> 1,
	 	    'sproduct_type'=> 2,
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    //'sproduct_d_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	
	 	 'sproduct_dh_price_set'=> (int)$_REQUEST['m_sp_price_set'],
	 	'sproduct_dh_price_one'=> $_REQUEST['m_sp_price_one'],
	 	'sproduct_dh_price_two'=> $_REQUEST['m_sp_price_two'],
	 	'sproduct_dh_price_three'=> $_REQUEST['m_sp_price_three'],
	 	'sproduct_dh_price_four'=> $_REQUEST['m_sp_price_four'],
	 	
	 	'sproduct_dh_price_five'=> $_REQUEST['m_sp_price_five'],
	 	'sproduct_dh_price_six'=> $_REQUEST['m_sp_price_six'],
	 	
	 	);
	 	$result = add_service_product($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	if(isset($_REQUEST['m_sp_vip']) and ($_REQUEST['m_sp_vip'] == 1)){
	 	$inrow2 = array(
	 		'vip_apply_sp_code'=> $sproduct_code,
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = add_vip_sproduct_apply($inrow2);
	 	}
        //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
    //发布代驾服务商品
    function addSPDaijia(){
        if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
        if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
    $uprow['member_role'] = 1;
	    $uprow['member_uptime'] = date('Y-m-d H:i:s');
	    $result = update_member($_REQUEST['m_code'],$uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	
		$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$inrow = array(
	 		'sproduct_code'=> $sproduct_code,
	 		'sproduct_m_code'=> $_REQUEST['m_code'],
	 	    'sproduct_state'=> 1,
	 	    'sproduct_type'=> 3,
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    'sproduct_dr_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	);
	 	$result = add_service_product($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	if(isset($_REQUEST['m_sp_vip']) and ($_REQUEST['m_sp_vip'] == 1)){
	 	$inrow2 = array(
	 		'vip_apply_sp_code'=> $sproduct_code,
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = add_vip_sproduct_apply($inrow2);
	 	}
        //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
    //读取商品列表
	function getSPList(){
	    if(!isset($_REQUEST['m_state'])){	//参数m_state 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(isset($_REQUEST['m_state']) and ($_REQUEST['m_state'] == '')){	//参数m_state 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
		$sql = ' select a.sproduct_code as sp_code,a.sproduct_type as sp_type,a.sproduct_p_price as sp_p_price,
		a.sproduct_d_price as sp_d_price,a.sproduct_dr_price as sp_dr_price,a.sproduct_name as sp_name,
		a.sproduct_server_from_time as sp_s_time, a.sproduct_server_to_time as sp_e_time,a.sproduct_reference as sp_about,
		a.sproduct_is_vip as sp_vip,b.at_name as sp_from_area,c.at_name as sp_to_area
		  from bc_service_product a ';
		$sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_state ='.(int)$_REQUEST['m_state'];
	 	$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	    //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' =>$result));
	 	die();
	}
    function DelSP(){
    	$result = del_service_product($_REQUEST['sp_code']);
        if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    	
    }
	//读取常用地址 及 推荐地址
	function getURAddressList(){
		$list = array();
	    //常用地址
	    $sql = ' select ua_id as id,ua_name as name,ua_address as address,ua_latitudee6 as latitudee6,ua_longitudee6 as longitudee6
	     from bc_useful_addresses ';
	 	//$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' where ua_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' order by ua_addtime asc ';
	 	$result = get_info_by_sql($sql);
	 	foreach ($result as $key => $value){
	 		$list[] = $value;
	 	}
	 	unset($result,$sql);
	 	//要修改 行政地 坐标
		//推荐地址
	    $sql = ' select a.ra_id as id,a.ra_name as name,a.ra_address as address,a.ra_latitudee6 as latitudee6,
	    a.ra_longitudee6 as longitudee6,b.at_address_hf,b.at_address_xz,b.at_type,b.at_distance,
	    b.at_dd_address,b.at_latitudee6,b.at_longitudee6
	     
	    from bc_recommended_addresses a';
	 	$sql.= ' left join bc_address_type b on a.ra_at_id=b.at_id';
	 	$sql.= ' where a.ra_id<>""';
	 	
	 	$mlatitudee6=0;$mlongitudee6=0;
	 	if($_REQUEST['m_ad_xz']){
	 		//$sql.= ' and b.at_address_xz ="'.$_REQUEST['m_ad_xz'].'"';
	 		$ad_pts= split(",",$_REQUEST['m_ad_pt']);
	 		$mlatitudee6 = $ad_pts[0];
	 		$mlongitudee6 = $ad_pts[1];
	 	}
	 	//$sql.= ' order by ra_addtime asc ';
	 	$sql.= ' order by a.ra_sort <> 0 desc ,a.ra_sort asc ';
	 	$result = get_info_by_sql($sql);
	 	//print_R($result);
	 	$f_isvip= 0;
	 	foreach ($result as $key => $value){
	 		$f_isvip= 0;
	 	    //三种 方法
	 	     //方法一 行政区 必须
	 	//echo str_replace($value['at_address_xz'],"",$_REQUEST['m_ad_xz']),'=',$_REQUEST['m_ad_xz'],'[]';
	 	
	 	if(str_replace($value['at_address_xz'],"", $_REQUEST['m_ad_xz']) != $_REQUEST['m_ad_xz']){
	 		if($value['at_type']==1) $f_isvip= 1;
	 				//方法二 定点
	 	    if($value['at_type']==2){
	 				    //定点的距离
        		        //if($value_['at_dd_address'] != ""){
        		///echo GetDistance($mlatitudee6,$mlongitudee6,$value['at_latitudee6'],$value['at_longitudee6'], 1),'=',$value['at_distance'];
        		if(GetDistance($mlatitudee6,$mlongitudee6,$value['at_latitudee6'],$value['at_longitudee6'], 1)  <= $value['at_distance'])
        		    $f_isvip= 1;
        		        //}
	 		}
	 		//方法三 地图标记
	 		if($value['at_type']==3){
	 			if(true === isInAare($mlongitudee6,$mlatitudee6,$value['at_address_hf']))$f_isvip= 1;
	 		}	
	   }
	 		
	 		
	 	   // echo $f_isvip;
	 		if($f_isvip == 0)continue;
	 		$list[] = $value;
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	 	
	}
	//发布拼车信息
    function addPinche(){
    	//判断是否 发 三天 内 未选标的 超过 15
    	$cnt = 0;  
    	$sql = ' select count(demand_code) as cnt from bc_demand ';
	 	$sql.= ' where demand_push_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and (demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
	 	$sql.= ' and demand_state = 0 ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt >= 15){
    		echo json_encode(array('state' => 1,'err-code' => 'x002'));//这三天内未选标交易的信息已经有15条了，请删除一些没用的信息！ 
	 	    die();
    	}
    	unset($result,$sql);
    	$m_from_area_lt = "";$m_to_area_lt = "";
    	if($_REQUEST['m_from_area']){
    	    $m_from_area_s = split("-", $_REQUEST['m_from_area']);
    	    $m_from_area_lt = $m_from_area_s[0].'-'.$m_from_area_s[1].'-'.$m_from_area_s[2].'-';
    	}
    	if($_REQUEST['m_to_area']){
    		$m_to_area_s = split("-", $_REQUEST['m_to_area']);
    	    $m_to_area_lt = $m_to_area_s[0].'-'.$m_to_area_s[1].'-'.$m_to_area_s[2].'-';
    	}
    	$from_latitudee6 = "";
    	$from_longitudee6= "";
    	if($_REQUEST['m_from_geopoint']){
    	$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
    	$from_latitudee6 = $tmp_one[0];
    	$from_longitudee6= $tmp_one[1];}
        $to_latitudee6 = "";
    	$to_longitudee6= "";
    	if($_REQUEST['m_to_geopoint']){
    	$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
    	$to_latitudee6 = $tmp_two[0];
    	$to_longitudee6= $tmp_two[1];}
    	//是否有vip 服务商品 s
    	$sql = 'select a.sproduct_code,b.at_m_code as at_f_m_code,c.at_m_code as at_t_m_code,
    	
    	b.at_distance as f_distance,b.at_dd_address as f_dd_address,
    	b.at_latitudee6 as f_at_latitudee6,b.at_longitudee6 as f_at_longitudee6,
    	b.at_type as  f_type,c.at_type as t_type,
    	c.at_dd_address as t_dd_address,c.at_latitudee6 as t_at_latitudee6,c.at_longitudee6 as t_at_longitudee6,
    	
    	c.at_distance as t_distance,b.at_address_hf as f_address_hf,c.at_address_hf as t_address_hf,
    	bi.sa_latitudee6 as f_latitudee6,bi.sa_longitudee6 as f_longitudee6,
    	ci.sa_latitudee6 as t_latitudee6,ci.sa_longitudee6 as t_longitudee6
    	    from bc_service_product a ';
    	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
    	$sql.= ' left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
    	$sql.= ' left join bc_shop_address bi on b.at_m_code=bi.sa_m_code ';
    	$sql.= ' left join bc_shop_address ci on c.at_m_code=ci.sa_m_code ';
    	
    	$sql.= ' where a.sproduct_state= 1  and a.sproduct_type = 1 ';
    	$sql.= ' and a.sproduct_is_vip = 1 ';
    	/*$sql.= ' and ((a.sproduct_from_at_id ="" )';
    	if($m_from_area_lt)
    	     $sql.= ' or (b.at_address_xz like "'.$m_from_area_lt.'%") ';
    	$sql.= '  )';
    	$sql.= ' and ((a.sproduct_to_at_id ="" )';
    	if($m_to_area_lt)
    	     $sql.= ' or (c.at_address_xz like "'.$m_to_area_lt.'%") ';
    	$sql.= '  )';     */
    	$result = get_info_by_sql($sql);
    	$f_isvip =0;$t_isvip =0;$isvip =0;
    	
        foreach ($result as $key => $value){
        //from 出发地 符合条件
	        //三种 方法
	 		//方法一 行政区
	               //if($value['f_type']==1){
	 				//	if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area'])
	 				//        $f_val = 1;
	 				//}
	 				if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area']){
	 					if($value['f_type']==1) $f_val= 1;
	 				//方法二 定点
	 				if($value['f_type']==2){
	 				    //定点的距离
        		       // if($value_['f_dd_address'] == 1){
        		            if(GetDistance($value['f_at_latitudee6'],$value['f_at_longitudee6'],$from_latitudee6,$from_longitudee6, 1)  <= $value_['f_distance'])
        		               $f_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['f_type']==3){
	 					if(true === isInAare($from_longitudee6,$from_latitudee6,$value['f_address_hf'])) $f_val= 1;
	 				}
	 				}
        	
        	//echo $f_isvip;
        	//目的地
	              // if($value['t_type']==1){
	 				//	if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area'])
	 				//        $t_val = 1;
	 				//}
	 				if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area']){
	 					if($value['t_type']==1) $t_val= 1;
	 				//方法二 定点
	 				if($value['t_type']==2){
	 				    //定点的距离
        		        //if($value_['t_dd_address'] == 1){
        		            if(GetDistance($value['t_at_latitudee6'],$value['t_at_longitudee6'],$to_latitudee6,$to_longitudee6, 1)  <= $value_['t_distance'])
        		               $t_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['t_type']==3){
	 					if(true === isInAare($to_longitudee6,$to_latitudee6,$value['t_address_hf'])) $t_val= 1;
	 				}}

        }
        if(($f_val+ $t_val) == 2)$isvip= 1;
    	//if(($f_val == 1) && ($t_val == 1))$isvip= 1;
    	//echo "==",$f_isvip,$t_isvip,$isvip;
    	unset($result,$sql);
    	//是否有vip 服务商品 end
    	$demand_code = $_REQUEST['m_code'].date('YmdHis');
	 	$inrow = array(
	 		'demand_code'=> $demand_code,
	 		'demand_push_m_code'=> $_REQUEST['m_code'],
	 	    'demand_type'=> 1,
	 	    'demand_hs_vip'=> $isvip,
	 	    'demand_p_count'=> $_REQUEST['m_count'],
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
	 	
	 	'demand_reference_maps'=> $_REQUEST['map_names'],
	 	'demand_is_baoche'=> $_REQUEST['m_baoche'],
	 	'demand_ntop_one'=> $_REQUEST['m_ntop_one'],
	 	'demand_ntop_two'=> $_REQUEST['m_ntop_two'],
	 	'demand_ntop_three'=> $_REQUEST['m_ntop_three'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 		'demand_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	if($_REQUEST['m_from_geopoint']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$inrow['demand_from_latitudee6'] = $tmp_one[0];
	 		$inrow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_geopoint']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$inrow['demand_to_latitudee6'] = $tmp_two[0];
	 		$inrow['demand_to_longitudee6'] = $tmp_two[1];
	 	}	
	 		
	 		
        $result = add_demand($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//修改 拼车信息
	function editPinche(){
		$uprow = array(
	 	    'demand_p_count'=> $_REQUEST['m_count'],
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
		'demand_reference_maps'=> $_REQUEST['map_names'],
	 	'demand_is_baoche'=> $_REQUEST['m_baoche'],
	 	'demand_ntop_one'=> $_REQUEST['m_ntop_one'],
	 	'demand_ntop_two'=> $_REQUEST['m_ntop_two'],
	 	'demand_ntop_three'=> $_REQUEST['m_ntop_three'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	    if($_REQUEST['m_from_area']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$uprow['demand_from_latitudee6'] = $tmp_one[0];
	 		$uprow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_area']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$uprow['demand_to_latitudee6'] = $tmp_two[0];
	 		$uprow['demand_to_longitudee6'] = $tmp_two[1];
	 	}
	 	$result = update_demand($_REQUEST['d_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//修改 代驾信息
	function editDaijia(){
		$uprow = array(
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
		'demand_reference_maps'=> $_REQUEST['map_names'],
	 	    'demand_car_type'=> $_REQUEST['m_type'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	    if($_REQUEST['m_from_area']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$uprow['demand_from_latitudee6'] = $tmp_one[0];
	 		$uprow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_area']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$uprow['demand_to_latitudee6'] = $tmp_two[0];
	 		$uprow['demand_to_longitudee6'] = $tmp_two[1];
	 	}
	 	$result = update_demand($_REQUEST['d_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//修改 带货信息
	function editDaihuo(){
	    $uprow = array(
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 	    'demand_d_name'=> $_REQUEST['m_gname'],
	 	    'demand_d_count'=> $_REQUEST['m_count'],
	 	    'demand_d_weight'=> $_REQUEST['m_weight'],
	 	    'demand_d_price'=> $_REQUEST['m_price'],
	    'demand_reference_maps'=> $_REQUEST['map_names'],
	 	'demand_dh_ntop_one'=> $_REQUEST['m_ntop_one'],
	 	'demand_dh_ntop_two'=> $_REQUEST['m_ntop_two'],
	 	'demand_dh_ntop_three'=> $_REQUEST['m_ntop_three'],
	 	    //'demand_ct_name'=> $_REQUEST['m_ct_name'],
	 	    'demand_ct_tel'=> $_REQUEST['m_ct_tel'],
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	if($_REQUEST['m_from_area']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$uprow['demand_from_latitudee6'] = $tmp_one[0];
	 		$uprow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_area']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$uprow['demand_to_latitudee6'] = $tmp_two[0];
	 		$uprow['demand_to_longitudee6'] = $tmp_two[1];
	 	}
	 	$result = update_demand($_REQUEST['d_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
	//发布代驾信息
	function addDaijia(){
	    //判断是否 发 三天 内 未选标的 超过 15
    	$cnt = 0;  
    	$sql = ' select count(demand_code) as cnt from bc_demand ';
	 	$sql.= ' where demand_push_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and (demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
	 	$sql.= ' and demand_state = 0 ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt >= 15){
    		echo json_encode(array('state' => 1,'err-code' => 'x002'));//这三天内未选标交易的信息已经有15条了，请删除一些没用的信息！ 
	 	    die();
    	}
    	unset($result,$sql);
    	$m_from_area_lt = "";$m_to_area_lt = "";
    	if($_REQUEST['m_from_area']){
    	    $m_from_area_s = split("-", $_REQUEST['m_from_area']);
    	    $m_from_area_lt = $m_from_area_s[0].'-'.$m_from_area_s[1].'-'.$m_from_area_s[2].'-';
    	}
    	if($_REQUEST['m_to_area']){
    		$m_to_area_s = split("-", $_REQUEST['m_to_area']);
    	    $m_to_area_lt = $m_to_area_s[0].'-'.$m_to_area_s[1].'-'.$m_to_area_s[2].'-';
    	}
    	$from_latitudee6 = "";
    	$from_longitudee6= "";
    	if($_REQUEST['m_from_geopoint']){
    	$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
    	$from_latitudee6 = $tmp_one[0];
    	$from_longitudee6= $tmp_one[1];}
        $to_latitudee6 = "";
    	$to_longitudee6= "";
    	if($_REQUEST['m_to_geopoint']){
    	$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
    	$to_latitudee6 = $tmp_two[0];
    	$to_longitudee6= $tmp_two[1];}
    	//是否有vip 服务商品 s
    	$sql = 'select a.sproduct_code,b.at_m_code as at_f_m_code,c.at_m_code as at_t_m_code,
    	b.at_distance as f_distance,b.at_dd_address as f_dd_address,
    	b.at_latitudee6 as f_at_latitudee6,b.at_longitudee6 as f_at_longitudee6,
    	b.at_type as  f_type,c.at_type as t_type,
    	c.at_dd_address as t_dd_address,c.at_latitudee6 as t_at_latitudee6,c.at_longitudee6 as t_at_longitudee6,
    	
    	
    	c.at_distance as t_distance,b.at_address_hf as f_address_hf,c.at_address_hf as t_address_hf,
    	bi.sa_latitudee6 as f_latitudee6,bi.sa_longitudee6 as f_longitudee6,
    	ci.sa_latitudee6 as t_latitudee6,ci.sa_longitudee6 as t_longitudee6
    	    from bc_service_product a ';
    	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
    	$sql.= ' left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
    	$sql.= ' left join bc_shop_address bi on b.at_m_code=bi.sa_m_code ';
    	$sql.= ' left join bc_shop_address ci on c.at_m_code=ci.sa_m_code ';
    	
    	$sql.= ' where a.sproduct_state= 1  and a.sproduct_type = 1 ';
    	$sql.= ' and a.sproduct_is_vip = 1 ';
    	/*$sql.= ' and ((a.sproduct_from_at_id ="" )';
    	if($m_from_area_lt)
    	     $sql.= ' or (b.at_address_xz like "'.$m_from_area_lt.'%") ';
    	$sql.= '  )';
    	$sql.= ' and ((a.sproduct_to_at_id ="" )';
    	if($m_to_area_lt)
    	     $sql.= ' or (c.at_address_xz like "'.$m_to_area_lt.'%") ';
    	$sql.= '  )';    */ 
    	$result = get_info_by_sql($sql);
    	$f_isvip =0;$t_isvip =0;$isvip =0;
	    foreach ($result as $key => $value){
	     //from 出发地 符合条件
	        //三种 方法
	 		//方法一 行政区
	               //if($value['f_type']==1){
	 				//	if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area'])
	 				//        $f_val = 1;
	 				//}
	 				if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area']){
	 					if($value['f_type']==1) $f_val= 1;
	 				//方法二 定点
	 				if($value['f_type']==2){
	 				    //定点的距离
        		        //if($value_['f_dd_address'] == 1){
        		            if(GetDistance($value['f_at_latitudee6'],$value['f_at_longitudee6'],$from_latitudee6,$from_longitudee6, 1)  <= $value_['f_distance'])
        		               $f_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['f_type']==3){
	 					if(true === isInAare($from_longitudee6,$from_latitudee6,$value['f_address_hf'])) $f_val= 1;
	 				}
	 				}
        	//echo $f_isvip;
        	//目的地
	               //if($value['t_type']==1){
	 				//	if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area'])
	 				//        $t_val = 1;
	 				//}
	 				if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area']){
	 					if($value['t_type']==1) $t_val= 1;
	 				//方法二 定点
	 				if($value['t_type']==2){
	 				    //定点的距离
        		        //if($value_['t_dd_address'] == 1){
        		            if(GetDistance($value['t_at_latitudee6'],$value['t_at_longitudee6'],$to_latitudee6,$to_longitudee6, 1)  <= $value_['t_distance'])
        		               $t_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['t_type']==3){
	 					if(true === isInAare($to_longitudee6,$to_latitudee6,$value['t_address_hf'])) $t_val= 1;
	 				}
	 				}
        }
        if(($f_val+ $t_val) == 2)$isvip= 1;
    	//if(($f_val == 1) && ($t_val == 1))$isvip= 1;
    	
    	unset($result,$sql);
    	//是否有vip 服务商品 end
    	$demand_code = $_REQUEST['m_code'].date('YmdHis');
	 	$inrow = array(
	 		'demand_code'=> $demand_code,
	 		'demand_push_m_code'=> $_REQUEST['m_code'],
	 	    'demand_type'=> 3,
	 	    'demand_hs_vip'=> $isvip,
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
	 	    'demand_reference_maps'=> $_REQUEST['map_names'],
	 	    'demand_car_type'=> $_REQUEST['m_type'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 		'demand_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	if($_REQUEST['m_from_geopoint']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$inrow['demand_from_latitudee6'] = $tmp_one[0];
	 		$inrow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_geopoint']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$inrow['demand_to_latitudee6'] = $tmp_two[0];
	 		$inrow['demand_to_longitudee6'] = $tmp_two[1];
	 	}	
	 		
	 		
        $result = add_demand($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	
	}
	//根据联系人名称取得联系地址 电话
	function getAddressFromContact(){
		$sql = ' select demand_ct_tel,demand_to_address,demand_to_latitudee6,demand_to_longitudee6 from bc_demand ';
	 	$sql.= ' where demand_push_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and demand_ct_name  = "'.$_REQUEST['m_ct_name'].'"';
	 	$sql.= ' and demand_type = 2 ';
	 	$sql.= ' order by demand_addtime desc ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$ct_tel = $result[0]['demand_ct_tel'];
	 	$to_address = $result[0]['demand_to_address'];
	 	$to_latitudee6 = $result[0]['demand_to_latitudee6'];
	 	$to_longitudee6 = $result[0]['demand_to_longitudee6'];
	 	echo json_encode(array('state' => 0,'err-code' => '','ct_tel' => $ct_tel,'to_address' => $to_address,
	 	'to_latitudee6' => $to_latitudee6,'to_longitudee6' => $to_longitudee6));
	 	die();
	}
	//发布带货信息
	function addDaihuo(){
		//判断是否 发 三天 内 未选标的 超过 15
    	$cnt = 0;  
    	$sql = ' select count(demand_code) as cnt from bc_demand ';
	 	$sql.= ' where demand_push_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and (demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" )';
	 	$sql.= ' and demand_state = 0 ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt >= 15){
    		echo json_encode(array('state' => 1,'err-code' => 'x002'));//这三天内未选标交易的信息已经有15条了，请删除一些没用的信息！ 
	 	    die();
    	}
    	unset($result,$sql);
    	$m_from_area_lt = "";$m_to_area_lt = "";
    	if($_REQUEST['m_from_area']){
    	    $m_from_area_s = split("-", $_REQUEST['m_from_area']);
    	    $m_from_area_lt = $m_from_area_s[0].'-'.$m_from_area_s[1].'-'.$m_from_area_s[2].'-';
    	}
    	if($_REQUEST['m_to_area']){
    		$m_to_area_s = split("-", $_REQUEST['m_to_area']);
    	    $m_to_area_lt = $m_to_area_s[0].'-'.$m_to_area_s[1].'-'.$m_to_area_s[2].'-';
    	}
    	$from_latitudee6 = "";
    	$from_longitudee6= "";
    	if($_REQUEST['m_from_geopoint']){
    	$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
    	$from_latitudee6 = $tmp_one[0];
    	$from_longitudee6= $tmp_one[1];}
        $to_latitudee6 = "";
    	$to_longitudee6= "";
    	if($_REQUEST['m_to_geopoint']){
    	$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
    	$to_latitudee6 = $tmp_two[0];
    	$to_longitudee6= $tmp_two[1];}
    	//是否有vip 服务商品 s
    	$sql = 'select a.sproduct_code,b.at_m_code as at_f_m_code,c.at_m_code as at_t_m_code,
    	b.at_distance as f_distance,b.at_dd_address as f_dd_address,
    	b.at_latitudee6 as f_at_latitudee6,b.at_longitudee6 as f_at_longitudee6,
    	c.at_dd_address as t_dd_address,c.at_latitudee6 as t_at_latitudee6,c.at_longitudee6 as t_at_longitudee6,
    	b.at_type as  f_type,c.at_type as t_type,
    	c.at_distance as t_distance,b.at_address_hf as f_address_hf,c.at_address_hf as t_address_hf,
    	bi.sa_latitudee6 as f_latitudee6,bi.sa_longitudee6 as f_longitudee6,
    	ci.sa_latitudee6 as t_latitudee6,ci.sa_longitudee6 as t_longitudee6
    	    from bc_service_product a ';
    	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
    	$sql.= ' left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
    	$sql.= ' left join bc_shop_address bi on b.at_m_code=bi.sa_m_code ';
    	$sql.= ' left join bc_shop_address ci on c.at_m_code=ci.sa_m_code ';
    	
    	$sql.= ' where a.sproduct_state= 1  and a.sproduct_type = 2 ';
    	$sql.= ' and a.sproduct_is_vip = 1 ';
    	/*$sql.= ' and ((a.sproduct_from_at_id ="" )';
    	if($m_from_area_lt)
    	     $sql.= ' or (b.at_address_xz like "'.$m_from_area_lt.'%") ';
    	$sql.= '  )';
    	$sql.= ' and ((a.sproduct_to_at_id ="" )';
    	if($m_to_area_lt)
    	     $sql.= ' or (c.at_address_xz like "'.$m_to_area_lt.'%") ';
    	$sql.= '  )';   */  
    	$result = get_info_by_sql($sql);
    	$f_isvip =0;$t_isvip =0;$isvip =0;
	    foreach ($result as $key => $value){
	        //from 出发地 符合条件
	        //三种 方法
	 		//方法一 行政区
	               //if($value['f_type']==1){
	 				//	if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area'])
	 				//        $f_val = 1;
	 				//}
	 				if(str_replace($value['f_address_xz'],"", $_REQUEST['m_from_area']) != $_REQUEST['m_from_area']){
	 					if($value['f_type']==1) $f_val= 1;
	 				//方法二 定点
	 				if($value['f_type']==2){
	 				    //定点的距离
        		        //if($value_['f_dd_address'] == 1){
        		            if(GetDistance($value['f_at_latitudee6'],$value['f_at_longitudee6'],$from_latitudee6,$from_longitudee6, 1)  <= $value_['f_distance'])
        		               $f_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['f_type']==3){
	 					if(true === isInAare($from_longitudee6,$from_latitudee6,$value['f_address_hf'])) $f_val= 1;
	 				}
	 				}
        	//echo $f_isvip;
        	//目的地
	               //if($value['t_type']==1){
	 				//	if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area'])
	 				//        $t_val = 1;
	 				//}
	 				if(str_replace($value['t_address_xz'],"", $_REQUEST['m_to_area']) != $_REQUEST['m_to_area']){
	 					if($value['t_type']==1) $t_val= 1;
	 				//方法二 定点
	 				if($value['t_type']==2){
	 				    //定点的距离
        		        //if($value_['t_dd_address'] == 1){
        		            if(GetDistance($value['t_at_latitudee6'],$value['t_at_longitudee6'],$to_latitudee6,$to_longitudee6, 1)  <= $value_['t_distance'])
        		               $t_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value['t_type']==3){
	 					if(true === isInAare($to_longitudee6,$to_latitudee6,$value['t_address_hf'])) $t_val= 1;
	 				}
	 				}
            
        }
    	if(($f_val+ $t_val) == 2)$isvip= 1;
    	
    	unset($result,$sql);
    	//是否有vip 服务商品 end
    	$demand_code = $_REQUEST['m_code'].date('YmdHis');
	 	$inrow = array(
	 		'demand_code'=> $demand_code,
	 		'demand_push_m_code'=> $_REQUEST['m_code'],
	 	    'demand_type'=> 2,
	 	    'demand_hs_vip'=> $isvip,
	 	    'demand_from_address'=> $_REQUEST['m_from_area'],
	 	    'demand_to_address'=> $_REQUEST['m_to_area'],
	 	    'demand_reference'=> $_REQUEST['m_bcsm'],
	 		'demand_time'=> date('Y-m-d H:i', strtotime($_REQUEST['m_time'])),
	 	    'demand_d_name'=> $_REQUEST['m_gname'],
	 	    'demand_d_count'=> $_REQUEST['m_count'],
	 	    'demand_d_weight'=> $_REQUEST['m_weight'],
	 	    'demand_d_price'=> $_REQUEST['m_price'],
	 	    //'demand_ct_name'=> $_REQUEST['m_ct_name'],
	 	   'demand_ct_tel'=> $_REQUEST['m_ct_tel'],
	 	    'demand_reference_maps'=> $_REQUEST['map_names'],
	 	'demand_dh_ntop_one'=> $_REQUEST['m_ntop_one'],
	 	'demand_dh_ntop_two'=> $_REQUEST['m_ntop_two'],
	 	'demand_dh_ntop_three'=> $_REQUEST['m_ntop_three'],
	 		'demand_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	if($_REQUEST['m_from_geopoint']){
	 		$tmp_one =split(",", $_REQUEST['m_from_geopoint']) ;
	 		$inrow['demand_from_latitudee6'] = $tmp_one[0];
	 		$inrow['demand_from_longitudee6'] = $tmp_one[1];
	 	}
        if($_REQUEST['m_to_geopoint']){
	 		$tmp_two =split(",", $_REQUEST['m_to_geopoint']) ;
	 		$inrow['demand_to_latitudee6'] = $tmp_two[0];
	 		$inrow['demand_to_longitudee6'] = $tmp_two[1];
	 	}
        $result = add_demand($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//取得需求信息 收到 有多少新需求 推送信息
	function getRDemandsForPush(){
		//
		$sql = ' select member_code,member_role,member_latitudee6,member_longitudee6,
		member_receive_info,member_receive_range
		 from bc_member ';
		$sql.= ' where member_code = "'.$_REQUEST['m_code'].'" ';
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$member_role = $result[0]['member_role'];
	 	
	 	$member_latitudee6 = $result[0]['member_latitudee6'];
	 	$member_longitudee6 = $result[0]['member_longitudee6'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	if($member_role == 0){
	 		echo json_encode(array('state' => 1,'err-code' => 'x002'));//非商家无法！ 
	 	    die();
	 	}
	 	unset($sql,$result);
	 	//xitong
	    $sql = ' select system_vip_time,system_vip_noselected_time from bc_system ';
		
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$vip_time = $result[0]['system_vip_time'];
	 	$vip_noselected_time = $result[0]['system_vip_noselected_time'];
	 	unset($sql,$result);
	 	//自己的商品
	 	$sql = 'select a.sproduct_code,b.at_m_code as at_f_m_code,c.at_m_code as at_t_m_code,
	 	a.sproduct_type,a.sproduct_is_vip,b.at_address_xz as f_address_xz,c.at_address_xz as t_address_xz,
    	b.at_distance as f_distance,b.at_dd_address as f_dd_address,
    	b.at_latitudee6 as f_at_latitudee6,b.at_longitudee6 as f_at_longitudee6
    	,c.at_distance as t_distance,b.at_address_hf as f_address_hf,c.at_address_hf as t_address_hf,
    	c.at_dd_address as t_dd_address,c.at_latitudee6 as t_at_latitudee6,c.at_longitudee6 as t_at_longitudee6,
    	b.at_type as  f_type,c.at_type as t_type,
    	a.sproduct_pc_price_set,a.sproduct_pc_price_one,a.sproduct_pc_price_bc,a.sproduct_pc_price_two,
    	a.sproduct_pc_price_two_bc,a.sproduct_pc_price_three,a.sproduct_pc_price_three_bc,
    	a.sproduct_pc_price_four,a.sproduct_pc_price_four_bc,a.sproduct_pc_price_f_t,a.sproduct_pc_price_f_t_bc,
    	a.sproduct_pc_price_tmore,a.sproduct_pc_price_tmore_bc,
    	a.sproduct_dh_price_set,a.sproduct_dh_price_one,a.sproduct_dh_price_two,a.sproduct_dh_price_three,
    	a.sproduct_dh_price_four,a.sproduct_dh_price_five,a.sproduct_dh_price_six,
    	a.sproduct_dr_price,a.sproduct_from_at_id,a.sproduct_to_at_id,
    	bi.sa_latitudee6 as f_latitudee6,bi.sa_longitudee6 as f_longitudee6,
    	ci.sa_latitudee6 as t_latitudee6,ci.sa_longitudee6 as t_longitudee6
    	    from bc_service_product a ';
    	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
    	$sql.= ' left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
    	$sql.= ' left join bc_shop_address bi on b.at_m_code=bi.sa_m_code ';
    	$sql.= ' left join bc_shop_address ci on c.at_m_code=ci.sa_m_code ';
    	$sql.= ' where a.sproduct_state= 1  ';
    	$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['m_code'].'" ';
    	$result_p = get_info_by_sql($sql);
	 	unset($sql,$result);
		//现在是测试用  正式的是 用判断信息 是否 可以收到
	   $sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_to_address,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,c.m_tcount,a.demand_state,a.demand_d_weight,
	     b.member_latitudee6,b.member_longitudee6,a.demand_from_latitudee6,a.demand_from_longitudee6
	     ,b.member_sex,b.member_buyer_pm,
	     a.demand_to_latitudee6,demand_to_longitudee6,a.demand_hs_vip,
              (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(a.demand_addtime)) as d_time,d.dread_id,
              (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(c.dt_time)) as d_time2
	     from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount,max(dtender_addtime) as dt_time from bc_demand_tender where dtender_state in (0,1,3) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	    
	     $sql.= ' left join (select dread_d_code,dread_m_code,dread_id from bc_demand_read where dread_m_code="'.$_REQUEST['m_code'].'"
	        ) d on a.demand_code = d.dread_d_code ';
	    
	 	$sql.= ' where a.demand_state in (0,1) ';
	 	$sql.= ' and a.demand_code not in ( select dtender_demand_code from bc_demand_tender ';
	 	$sql.= '  where dtender_m_code = "'.$_REQUEST['m_code'].'" and dtender_state in (0,1,3) )';
	 	$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
        $sql.= ' and (a.demand_time like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+1 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+3 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+2 day')).'%" )';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	$sql.= ' and a.demand_push_m_code <> "'.$_REQUEST['m_code'].'" ';
	 	if($_REQUEST['m_d_codes']){
	 		$dcodes = explode("_",$_REQUEST['m_d_codes']);
	 		$str_codes = "";
	 		foreach ($dcodes as $value) {
	 			if($str_codes != "")$str_codes .=',';
	 			$str_codes .='"'.$value.'"';
	 		}
	 		$sql.= ' and a.demand_code not in ('.$str_codes.')';
	 	}
	 	     
	 	$sql.= ' and d.dread_id IS NULL ';
	 	$sql.= 'order by a.demand_addtime desc ';
	 	$result = get_info_by_sql($sql);
	 	//print_r($result);
	 	$list = array();$tmp = array();
	 	$in_myqu = 0;
	 	//信息过滤
	 	foreach ($result as $key => $value){
	 		$in_myqu = 0;$f_val = 0;$t_val = 0;$in_vip = 0;
	 		$curk = 0;
	 		//在自己的服务区
	 		foreach ($result_p as $key_ => $value_){
	 			if($value['demand_type'] != $value_['sproduct_type'])continue;
	 			
	 			if($value_['sproduct_from_at_id']=="")$f_val = 1;
	 			//from 出发地 符合条件
	 			if($value['demand_from_address']==""){
	 				$f_val = 1;
	 			}else{
	 				//三种 方法
	 				//方法一 行政区 必须
	 				if(str_replace($value_['f_address_xz'],"", $value['demand_from_address']) != $value['demand_from_address']){
	 				if($value_['f_type']==1) $f_val= 1;
	 				//方法二 定点
	 				if($value_['f_type']==2){
	 				    //定点的距离
        		        //if($value_['f_dd_address'] == 1){
        		            if(GetDistance($value_['f_at_latitudee6'],$value_['f_at_longitudee6'],$value['demand_from_latitudee6'],$value['demand_from_longitudee6'], 1)  <= $value_['f_distance'])
        		               $f_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value_['f_type']==3){
	 					if(true === isInAare($value['demand_from_longitudee6'],$value['demand_from_latitudee6'],$value_['f_address_hf'])) $f_val= 1;
	 				}
	 				
	 				}
	 				
	 			}
	 			if($value_['sproduct_to_at_id']=="")$t_val = 1;
	 			//to 目的地 符合条件
	 		    if($value['demand_to_address']==""){
	 		    	//echo 'tab 2';
	 				$t_val = 1;
	 			}else{
	 			    //三种 方法
	 				//方法一 行政区
	 				//if($value_['t_type']==1){
	 					//echo str_replace($value_['t_address_xz'],"", $value['demand_to_address']),'=',$value['demand_to_address'];
	 				//	if(str_replace($value_['t_address_xz'],"", $value['demand_to_address']) != $value['demand_to_address'])
	 				//        $t_val = 1;
	 				//}
	 				if(str_replace($value_['t_address_xz'],"", $value['demand_to_address']) != $value['demand_to_address']){
	 					if($value_['t_type']==1) $t_val= 1;
	 				//方法二 定点
	 				if($value_['t_type']==2){
	 				    //定点的距离
        		        //if($value_['t_dd_address'] == 1){
        		            if(GetDistance($value_['t_at_latitudee6'],$value_['t_at_longitudee6'],$value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 1)  <= $value_['t_distance'])
        		               $t_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value_['t_type']==3){
	 					if(true === isInAare($value['demand_to_longitudee6'],$value['demand_to_latitudee6'],$value_['t_address_hf'])) $t_val= 1;
	 				}
	 				}
	 				
	 			}
	 			//echo $f_val,'==',$t_val;
	 			if(($f_val+ $t_val) == 2)$in_myqu= 1;
	 			$in_vip = (int)$value_['sproduct_is_vip'];
	 			if($in_myqu== 1){
	 				$curk=$key_;break;
	 			}
	 			
	 		}
	 		//echo $f_val, $t_val,'=',$in_myqu;
	 		if($in_myqu== 0)continue;
	 		
	 		//是否是vip
	 		if($value['demand_hs_vip']== 1){
	 			if($in_vip==0){
	 			    if($value['m_tcount'] > 0){
	 			    	if($value['d_time2'] < $vip_noselected_time)continue;//时间未到
	 			    }else{
	 			    	if($value['d_time'] < $vip_time)continue;//时间未到
	 			    }
	 			}
	 		}
	 		$tmp['demand_code']=$result[$key]['demand_code'];
	 		//$tmp['demand_code']=$result[$key]['demand_code'];
	 		$list[] = $tmp;
	 		$tmp = array();
	 	}
	   
	 	echo json_encode(array('state' => 0,'err-code' => '','list' =>$list));
	 	die();
	}
	//取得需求信息 收到
	function getDemands(){
		//
		$sql = ' select member_code,member_role,member_latitudee6,member_longitudee6,
		member_receive_info,member_receive_range
		 from bc_member ';
		$sql.= ' where member_code = "'.$_REQUEST['m_code'].'" ';
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$member_role = $result[0]['member_role'];
	 	
	 	$member_latitudee6 = $result[0]['member_latitudee6'];
	 	$member_longitudee6 = $result[0]['member_longitudee6'];
	 	$member_receive_info = $result[0]['member_receive_info'];
	 	$member_receive_range = $result[0]['member_receive_range'];
	 	if($member_role == 0){
	 		echo json_encode(array('state' => 1,'err-code' => 'x002'));//非商家无法！ 
	 	    die();
	 	}
	 	unset($sql,$result);
	 	//xitong
	    $sql = ' select system_vip_time,system_vip_noselected_time from bc_system ';
		
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$vip_time = $result[0]['system_vip_time'];
	 	$vip_noselected_time = $result[0]['system_vip_noselected_time'];
	 	unset($sql,$result);
	 	//自己的商品
	 	$sql = 'select a.sproduct_code,b.at_m_code as at_f_m_code,c.at_m_code as at_t_m_code,
	 	a.sproduct_type,a.sproduct_is_vip,b.at_address_xz as f_address_xz,c.at_address_xz as t_address_xz,
    	b.at_distance as f_distance,b.at_dd_address as f_dd_address,
    	b.at_latitudee6 as f_at_latitudee6,b.at_longitudee6 as f_at_longitudee6
    	,c.at_distance as t_distance,b.at_address_hf as f_address_hf,c.at_address_hf as t_address_hf,
    	c.at_dd_address as t_dd_address,c.at_latitudee6 as t_at_latitudee6,c.at_longitudee6 as t_at_longitudee6,
    	b.at_type as  f_type,c.at_type as t_type,
    	a.sproduct_pc_price_set,a.sproduct_pc_price_one,a.sproduct_pc_price_bc,a.sproduct_pc_price_two,
    	a.sproduct_pc_price_two_bc,a.sproduct_pc_price_three,a.sproduct_pc_price_three_bc,
    	a.sproduct_pc_price_four,a.sproduct_pc_price_four_bc,a.sproduct_pc_price_f_t,a.sproduct_pc_price_f_t_bc,
    	a.sproduct_pc_price_tmore,a.sproduct_pc_price_tmore_bc,
    	
    	a.sproduct_dh_price_set,a.sproduct_dh_price_one,a.sproduct_dh_price_two,a.sproduct_dh_price_three,
    	a.sproduct_dh_price_four,a.sproduct_dh_price_five,a.sproduct_dh_price_six,
    	
    	a.sproduct_dr_price,a.sproduct_from_at_id,a.sproduct_to_at_id,
    	
    	
    	
    	bi.sa_latitudee6 as f_latitudee6,bi.sa_longitudee6 as f_longitudee6,
    	ci.sa_latitudee6 as t_latitudee6,ci.sa_longitudee6 as t_longitudee6
    	    from bc_service_product a ';
    	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
    	$sql.= ' left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
    	$sql.= ' left join bc_shop_address bi on b.at_m_code=bi.sa_m_code ';
    	$sql.= ' left join bc_shop_address ci on c.at_m_code=ci.sa_m_code ';
    	$sql.= ' where a.sproduct_state= 1  ';
    	$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['m_code'].'" ';
    	$result_p = get_info_by_sql($sql);
    	//print_r($result_p);
	 	//die();
	 	unset($sql,$result);
		//现在是测试用  正式的是 用判断信息 是否 可以收到
	    $sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_to_address,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,c.m_tcount,a.demand_state,a.demand_d_weight,
	     b.member_latitudee6,b.member_longitudee6,a.demand_from_latitudee6,a.demand_from_longitudee6
	     ,b.member_sex,b.member_buyer_pm,
	     a.demand_to_latitudee6,demand_to_longitudee6,a.demand_hs_vip,
              (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(a.demand_addtime)) as d_time,d.dread_id,
              (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(c.dt_time)) as d_time2
	     from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount,max(dtender_addtime) as dt_time from bc_demand_tender where dtender_state in (0,1,3) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	    
	     $sql.= ' left join (select dread_d_code,dread_m_code,dread_id from bc_demand_read where dread_m_code="'.$_REQUEST['m_code'].'"
	        ) d on a.demand_code = d.dread_d_code ';
	    
	 	$sql.= ' where a.demand_state in (0,1) ';
	 	$sql.= ' and a.demand_code not in ( select dtender_demand_code from bc_demand_tender ';
	 	$sql.= '  where dtender_m_code = "'.$_REQUEST['m_code'].'" and dtender_state in (0,1,3) )';
	 	$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
        $sql.= ' and (a.demand_time like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+1 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+3 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+2 day')).'%" )';
        if($_REQUEST['demand_type'])
	 	     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	$sql.= ' and a.demand_push_m_code <> "'.$_REQUEST['m_code'].'" ';
	 	/*$tmp_sql1 = '  and ((a.demand_from_address ="" )' ;
	 	$tmp_sql2 = '  and ((a.demand_to_address ="" )' ;
	 	$tmp_sql11 = "";$tmp_sql22 = "";
	 	foreach ($result_p as $key => $value){
	 		//出发地
        	if($value['f_address_xz']){
        		$f_address_xz_s = split("-", $value['f_address_xz']);
    	        $f_address_xz_lt = $f_address_xz_s[0].'-'.$f_address_xz_s[1].'-'.$f_address_xz_s[2].'-';
    	        $tmp_sql11.= ' or (a.demand_from_address like "'.$f_address_xz_lt.'%") ';
        	}
        	//目的地
	 	    if($value['t_address_xz']){
        		$t_address_xz_s = split("-", $value['t_address_xz']);
    	        $t_address_xz_lt = $t_address_xz_s[0].'-'.$t_address_xz_s[1].'-'.$t_address_xz_s[2].'-';
    	        $tmp_sql22.= ' or (a.demand_to_address like "'.$t_address_xz_lt.'%") ';
        	}
	 	}
	 	if($tmp_sql11)$sql.= $tmp_sql1.$tmp_sql11.' )';
	 	if($tmp_sql22)$sql.= $tmp_sql2.$tmp_sql22.' )';*/
	 	$sql.= 'order by a.demand_addtime desc ';
	 	//echo $sql;
	 	$result = get_info_by_sql($sql);
	 	//print_r($result);
	 	//die();
	 	$list = array();
	 	$in_myqu = 0;
	 	//信息过滤
	 	foreach ($result as $key => $value){
	 		$in_myqu = 0;$f_val = 0;$t_val = 0;$in_vip = 0;
	 		$curk = 0;
	 		//echo 'key =',$key;
	 		//在自己的服务区
	 		foreach ($result_p as $key_ => $value_){
	 			//echo 'key_ =',$key_;
	 			//echo 'key_ =',$key_;
	 			if($value['demand_type'] != $value_['sproduct_type'])continue;
	 			
	 			if($value_['sproduct_from_at_id']=="")$f_val = 1;
	 			//from 出发地 符合条件
	 			if($value['demand_from_address']==""){
	 				$f_val = 1;
	 			}else{
	 				//三种 方法
	 				//方法一 行政区 必须
	 				if(str_replace($value_['f_address_xz'],"", $value['demand_from_address']) != $value['demand_from_address']){
	 				if($value_['f_type']==1) $f_val= 1;
	 				//方法二 定点
	 				if($value_['f_type']==2){
	 				    //定点的距离
        		        //if($value_['f_dd_address'] == 1){
        		            if(GetDistance($value_['f_at_latitudee6'],$value_['f_at_longitudee6'],$value['demand_from_latitudee6'],$value['demand_from_longitudee6'], 1)  <= $value_['f_distance'])
        		               $f_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value_['f_type']==3){
	 					if(true === isInAare($value['demand_from_longitudee6'],$value['demand_from_latitudee6'],$value_['f_address_hf'])) $f_val= 1;
	 				}
	 				
	 				}
	 				
	 				//if($value_['f_type']==1){
	 				//	if(str_replace($value_['f_address_xz'],"", $value['demand_from_address']) != $value['demand_from_address'])
	 				//        $f_val = 1;
	 				//}
	 				
	 				/*
	 			    //发布者 于我的距离  占时不要
        		    if($member_receive_info ==0){
        		        $g_distance = GetDistance($value['member_latitudee6'],$value['member_longitudee6'], $member_latitudee6,$member_longitudee6, 1);
        		        
        		        if($member_receive_range ==0){
        		            	if($g_distance <= 500)$f_val= 1;
        		        }else if($member_receive_range ==1){
        		            	if($g_distance <= 1000) $f_val= 1;
        		        }else if($member_receive_range ==2){
        		            	if($g_distance <= 2000) $f_val= 1;
        		        }else if($member_receive_range ==3){
        		            	if($g_distance <= 5000) $f_val= 1;
        		        }else if($member_receive_range ==4){
        		            	if($g_distance <= 10000) $f_val= 1;
        		        }
        		    }*/
	 				
	 			}
	 			if($value_['sproduct_to_at_id']=="")$t_val = 1;
	 			//to 目的地 符合条件
	 		    if($value['demand_to_address']==""){
	 		    	//echo 'tab 2';
	 				$t_val = 1;
	 			}else{
	 			    //三种 方法
	 				//方法一 行政区
	 				//if($value_['t_type']==1){
	 					//echo str_replace($value_['t_address_xz'],"", $value['demand_to_address']),'=',$value['demand_to_address'];
	 				//	if(str_replace($value_['t_address_xz'],"", $value['demand_to_address']) != $value['demand_to_address'])
	 				//        $t_val = 1;
	 				//}
	 				if(str_replace($value_['t_address_xz'],"", $value['demand_to_address']) != $value['demand_to_address']){
	 					if($value_['t_type']==1) $t_val= 1;
	 				//方法二 定点
	 				if($value_['t_type']==2){
	 				    //定点的距离
        		        //if($value_['t_dd_address'] == 1){
        		            if(GetDistance($value_['t_at_latitudee6'],$value_['t_at_longitudee6'],$value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 1)  <= $value_['t_distance'])
        		               $t_val= 1;
        		        //}
	 				}
	 				//方法三 地图标记
	 				if($value_['t_type']==3){
	 					if(true === isInAare($value['demand_to_longitudee6'],$value['demand_to_latitudee6'],$value_['t_address_hf'])) $t_val= 1;
	 				}
	 				}
	 				/*
	 			    //发布者 于我的距离
	 			    if($member_receive_info ==0){
        		        $g_distance = GetDistance($value['member_latitudee6'],$value['member_longitudee6'], $member_latitudee6,$member_longitudee6, 1);
        		        
        		            if($member_receive_range ==0){
        		            	if($g_distance <= 500)$t_val= 1;
        		            }else if($member_receive_range ==1){
        		            	if($g_distance <= 1000) $t_val= 1;
        		            }else if($member_receive_range ==2){
        		            	if($g_distance <= 2000) $t_val= 1;
        		            }else if($member_receive_range ==3){
        		            	if($g_distance <= 5000) $t_val= 1;
        		            }else if($member_receive_range ==4){
        		            	if($g_distance <= 10000) $t_val= 1;
        		            }
        		   }*/
	 				
	 			}
	 			
	 			if(($f_val+ $t_val) == 2)$in_myqu= 1;
	 			$in_vip = (int)$value_['sproduct_is_vip'];
	 			if($in_myqu== 1){
	 				$curk=$key_;break;
	 			}
	 			
	 		}
	 		//echo $f_val, $t_val,'=',$in_myqu;
	 		if($in_myqu== 0)continue;
	 		
	 		//是否是vip
	 		if($value['demand_hs_vip']== 1){
	 			if($in_vip==0){
	 			    if($value['m_tcount'] > 0){
	 			    	if($value['d_time2'] < $vip_noselected_time)continue;//时间未到
	 			    }else{
	 			    	if($value['d_time'] < $vip_time)continue;//时间未到
	 			    }
	 			}
	 		}
	 		//if($in_myqu == 1){
	 		//计算价格
	 		$vm_price=0;$vm_sp_code="";
	 		$vm_sp_code=$result_p[$curk]['sproduct_code'];
	 		if($value['demand_type']==1){//pc
	 			if($result_p[$curk]['sproduct_pc_price_set'] == 0){
	 			    /*if($value['demand_p_count']==1){
	 			    	 $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_one_bc']:$result_p[$curk]['sproduct_pc_price_one']);
	 			    }
	 			    if($value['demand_p_count']==2){
	 			        $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_two_bc']:$result_p[$curk]['sproduct_pc_price_two']);
	 			    }
	 			    if($value['demand_p_count']==3){
	 			        $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_three_bc']:$result_p[$curk]['sproduct_pc_price_three']);
	 			    }
	 			    if($value['demand_p_count']==4){
	 			        $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_four_bc']:$result_p[$curk]['sproduct_pc_price_four']);
	 			    }
	 			    if(($value['demand_p_count'] > 4) && ($value['demand_p_count'] <= 10)) {
	 				    $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_f_t_bc']:$result_p[$curk]['sproduct_pc_price_f_t']);
	 			    }
	 			    if($value['demand_p_count']>10){
	 			        $vm_price =($result_p[$curk]['demand_is_baoche']==1?$result_p[$curk]['sproduct_pc_price_tmore_bc']:$result_p[$curk]['sproduct_pc_price_tmore']);
	 			    }
	 			    */
	 			    if($value['demand_p_count']==1)
	 			        $vm_price = $result_p[$curk]['sproduct_pc_price_one'];
	 			    if($value['demand_p_count']==2)
	 			        $vm_price = $result_p[$curk]['sproduct_pc_price_two'];
	 			    if($value['demand_p_count']==3)
	 			        $vm_price = $result_p[$curk]['sproduct_pc_price_three'];
	 			    if($value['demand_p_count']==4)
	 			        $vm_price = $result_p[$curk]['sproduct_pc_price_four'];
	 			    if(($value['demand_p_count'] > 4) && ($value['demand_p_count'] <= 10)) 
	 			        $vm_price =$result_p[$curk]['sproduct_pc_price_bc'];
	 			    if($value['demand_p_count'] > 10) 
	 			        $vm_price =$result_p[$curk]['sproduct_pc_price_bc'];
	 			    if($result_p[$curk]['demand_is_baoche'] == 1)
	 			        $vm_price =$result_p[$curk]['sproduct_pc_price_bc'];
	 			}else{
	 			    $vm_price = 0;
	 			}
	 			//
	 		}
	 	    if($value['demand_type']==2){//dh
	 	    	if($result_p[$curk]['sproduct_dh_price_set'] == 0){
	 	    	    if($value['demand_d_weight'] <=5 )
	 			    	$vm_price =$result_p[$curk]['sproduct_dh_price_one'];
	 			    if(($value['demand_d_weight'] > 5) && ($value['demand_d_weight'] <= 10))
	 			       $vm_price =$result_p[$curk]['sproduct_dh_price_two'];
	 			    if(($value['demand_d_weight'] > 10) && ($value['demand_d_weight'] <= 25))
	 			       $vm_price =$result_p[$curk]['sproduct_dh_price_three'];
	 			    if(($value['demand_d_weight'] > 25) && ($value['demand_d_weight'] <= 50))
	 			        $vm_price =$result_p[$curk]['sproduct_dh_price_four'];
	 			    if(($value['demand_d_weight'] > 50) && ($value['demand_d_weight'] <= 100))
	 			        $vm_price =$result_p[$curk]['sproduct_dh_price_five'];
	 			    if($value['demand_d_weight'] > 100)
	 			       $vm_price =$result_p[$curk]['sproduct_dh_price_six'];
	 	    	}else{
	 			    $vm_price = 0;
	 			}
	 		}
	 		
	 	    if($value['demand_type']==3){//dj
	 	    	$vm_price = $result_p[$curk]['sproduct_dr_price'];
	 		}
	 		$result[$key]['m_price']= $vm_price;
	 		$result[$key]['m_sp_code']= $vm_sp_code;
	 		
	 		
	 		$list[] = $result[$key];//}
	 	}
	    //foreach ($result as $key => $value){
	 	///	$result[$key]['ft_distance']=GetDistance($value['demand_from_latitudee6'],$value['demand_from_longitudee6'], $value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 1,2);
	 	//}
	    foreach ($list as $key => $value){
	 		$list[$key]['ft_distance']=GetDistance($value['demand_from_latitudee6'],$value['demand_from_longitudee6'], $value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 2,2);
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' =>$list));
	 	//echo json_encode(array('state' => 0,'err-code' => '','list' =>$result));
	 	
	 	die();
	}
	//投标接口
	function addTender(){
		//判断是否在修改中 无法投标
		$sql = ' select demand_code,demand_state,demand_push_m_code,demand_type from bc_demand ';
		$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$demand_state = $result[0]['demand_state'];
	 	$demand_push_m_code = $result[0]['demand_push_m_code'];
	 	$demand_type = $result[0]['demand_type'];
	 	$d_typs = array('','拼车','快递','代驾');
		if($demand_state == 1){
			echo json_encode(array('state' => 1,'err-code' => 'x002'));//服务器数据库开小差了哦！ 
	 	    die();
		}
		unset($result);
	    $cnt = 0;
	 	$sql = ' select count(dtender_demand_code) as cnt from bc_demand_tender ';
	 	$sql.= ' where dtender_demand_code ="'.$_REQUEST['d_code'].'"';
	 	$sql.= ' and dtender_m_code  ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
           // echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	  //  die();
	 	    $inrow = array(
	 	    'dtender_state'=> 0,
	 	   // 'dtender_sp_code'=> $_REQUEST['m_sp_code'],
	 	    'dtender_price'=> $_REQUEST['d_price'],
	 	    'dtender_reference'=> $_REQUEST['d_content'],
	 		'dtender_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	    $result = update_demand_tender( $_REQUEST['d_code'], $_REQUEST['m_code'],$inrow);
	        if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	    }
	 	
	 	}else{
	 	
	 	
	 	unset($result);
	    //$demand_code = $_REQUEST['m_code'].date('YmdHis');
	 	$inrow = array(
	 		'dtender_demand_code'=> $_REQUEST['d_code'],
	 		'dtender_m_code'=> $_REQUEST['m_code'],
	 	 'dtender_sp_code'=> $_REQUEST['m_sp_code'],
	 	    'dtender_state'=> 0,
	 	    'dtender_price'=> $_REQUEST['d_price'],
	 	    'dtender_reference'=> $_REQUEST['d_content'],
	 		'dtender_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_demand_tender($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	}
	 	unset($result);
	    $cnt = 0;
	 	$sql = ' select count(dtender_demand_code) as cnt from bc_demand_tender ';
	 	$sql.= ' where dtender_demand_code ="'.$_REQUEST['d_code'].'"';
	 	//$sql.= ' and dtender_m_code  ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	//投标通知
	 	$inrow = array(
	 	   'notice_title'=>'投标',
	 	   'notice_content'=>'亲，您发布的'.$d_typs[$demand_type].'需求有'.$cnt.'人投标！请注意查看！',
	 	   'notice_to_m_code'=>$demand_push_m_code,
	 	   'notice_d_code'=>$_REQUEST['d_code'],
	 	   'notice_is_receive'=>0,
	 	   'notice_addtime'=>date('Y-m-d H:i:s'),
	 	);
	 	add_notice($inrow);
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//获取需求的详细信息
	function getRDemand(){
		$cnt = 0;
	 	$sql = ' select count(dread_id) as cnt from bc_demand_read ';
	 	$sql.= ' where dread_d_code ="'.$_REQUEST['d_code'].'"';
	 	$sql.= ' and dread_m_code  ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result);
	 	if($cnt == 0){
            $inrow = array(
	 		'dread_id'=> $_REQUEST['d_code'].$_REQUEST['m_code'],
	 		'dread_m_code'=> $_REQUEST['m_code'],
	 	    'dread_d_code'=> $_REQUEST['d_code'],
	 		'dread_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 		add_demand_read($inrow);
	 	}
	 	unset($result);
		
		//$sql.= ' left join (select dread_d_code,dread_m_code,dread_id from bc_demand_read where dread_m_code="'.$_REQUEST['m_code'].'"
	      //  ) d on a.demand_code = d.dread_d_code ';
		
		
		
	    $sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_to_address,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,c.m_tcount,a.demand_d_count,a.demand_d_weight,
	     a.demand_reference,a.demand_ct_name,a.demand_d_price,a.demand_ct_tel,a.demand_d_name,a.demand_is_baoche,
	     a.demand_ntop_one,a.demand_ntop_two,a.demand_ntop_three,a.demand_from_latitudee6,a.demand_from_longitudee6,
		a.demand_to_latitudee6,a.demand_to_longitudee6
      ,a.demand_reference_maps,a.demand_dh_ntop_one,a.demand_dh_ntop_two,a.demand_dh_ntop_three,a.demand_car_type
	     from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount from bc_demand_tender  where dtender_state in (0,1) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	    
	    
	 	$sql.= ' where a.demand_state = 0 ';
	 	//$sql.= ' and a.demand_code not in ( select dtender_demand_code from bc_demand_tender ';
	 	//$sql.= '  where dtender_m_code = "'.$_REQUEST['m_code'].'" )';
	 	//$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" )';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	$sql.= ' and a.demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','demand_p_count' => $result[0]['demand_p_count'],
	 	'demand_from_address' => $result[0]['demand_from_address'],'demand_to_address' => $result[0]['demand_to_address']
	 	,'demand_addtime' => mdate3(strtotime($result[0]['demand_addtime'])),'demand_time' => mdate2(strtotime($result[0]['demand_time'].":00")),
	 	'member_name' => $result[0]['member_name'],'member_logo' => $result[0]['member_logo'],'m_tcount' => $result[0]['m_tcount']
	 	,'demand_d_count' => $result[0]['demand_d_count'],'demand_d_weight' => $result[0]['demand_d_weight']
	 	,'demand_from_latitudee6' => $result[0]['demand_from_latitudee6'],'demand_from_longitudee6' => $result[0]['demand_from_longitudee6']
	 	,'demand_to_latitudee6' => $result[0]['demand_to_latitudee6'],'demand_to_longitudee6' => $result[0]['demand_to_longitudee6']
	 	
	 	,'demand_reference' => $result[0]['demand_reference'],'demand_ct_name' => $result[0]['demand_ct_name']
	 	,'demand_d_price' => $result[0]['demand_d_price'],'demand_ct_tel' => $result[0]['demand_ct_tel']
	 	,'demand_d_name' => $result[0]['demand_d_name'],
	 	'demand_is_baoche' => $result[0]['demand_is_baoche'],'demand_ntop_one' => $result[0]['demand_ntop_one'],
	 	'demand_ntop_two' => $result[0]['demand_ntop_two'],'demand_ntop_three' => $result[0]['demand_ntop_three']
	 	,'demand_reference_maps' => $result[0]['demand_reference_maps'],'demand_dh_ntop_one' => $result[0]['demand_dh_ntop_one'],
	 	'demand_dh_ntop_two' => $result[0]['demand_dh_ntop_two'],'demand_dh_ntop_three' => $result[0]['demand_dh_ntop_three']
	 	,'demand_car_type' => $result[0]['demand_car_type']
	 	
	 	));
	 	die();
	}
	//取得需求信息 自己发布的
	function getPDemands(){
	    $sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_to_address,
	    a.demand_do_state,a.demand_p_map,a.demand_ok_state,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,c.m_tcount,a.demand_state from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount from bc_demand_tender where dtender_state in (0,1,3) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	 	$sql.= ' where a.demand_push_m_code = "'.$_REQUEST['m_code'].'" ';
	 	/*$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
        $sql.= ' and (a.demand_time like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+1 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+3 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+2 day')).'%" )';*/
	 	if($_REQUEST['d_lasttime'])
	 	   $sql.= ' and date(a.demand_addtime)  < "'.date('Y-m-d H:i:s',str_replace("_", " ", strtotime($_REQUEST['d_lasttime']))).'"';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	if($_REQUEST['demand_state']) {
	 		if($_REQUEST['demand_state'] == 1) $sql.= ' and a.demand_state = 0 and c.m_tcount is null ';
	 		if($_REQUEST['demand_state'] == 2) $sql.= ' and a.demand_state = 0 and c.m_tcount > 0 ';
	 		if($_REQUEST['demand_state'] == 3) $sql.= ' and a.demand_state = 2 ';
	 		if($_REQUEST['demand_state'] == 4) $sql.= ' and ((a.demand_state = 3) or (a.demand_state = 4)) ';
	 	}   
	 	     //1 未投标 2未选标 3进行中 4 已完成/已取消
	 	//$sql.= ' and a.demand_push_m_code <> "'.$_REQUEST['m_code'].'" ';
	 	$sql.= ' order by a.demand_addtime desc ';
	 	$sql.= ' limit 0,10 ';
	 	$result = get_info_by_sql($sql);
	 	//echo $sql;
	    //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' =>$result));
	 	die();
	}
	function setqzMap(){
	    $inrow = array(
	 		'demand_p_map'=> $_REQUEST['map_name'],
	        'demand_ok_state'=> 1,
	 		);
        $result = update_demand($_REQUEST['d_code'], $inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
    function setqzMap2(){
	    $inrow = array(
	 		'demand_s_map'=> $_REQUEST['map_name'],
	        'demand_do_state'=> 1,
	    
	 		);
        $result = update_demand($_REQUEST['d_code'], $inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	$sql = ' select demand_code,demand_state,demand_push_m_code,demand_type from bc_demand ';
		$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
		$result = get_info_by_sql($sql);
		$demand_type = $result[0]['demand_type'];
		$demand_push_m_code = $result[0]['demand_push_m_code'];
	 	$d_typs2 = array('','接人或完成交易','接件或完成交易','接车或完成交易');
	 	$d_typs = array('','拼车','快递','代驾');
	 	//接车通知 、接件、
	 	$inrow = array(
	 	   'notice_title'=>$d_typs2[$demand_type],
	 	   'notice_content'=>'亲，您的'.$d_typs[$demand_type].'需求已经'.$d_typs2[$demand_type].'！请注意确认！',
	 	   'notice_to_m_code'=>$demand_push_m_code,
	 	   'notice_d_code'=>$_REQUEST['d_code'],
	 	   'notice_is_receive'=>0,
	 	   'notice_addtime'=>date('Y-m-d H:i:s'),
	 	);
	 	add_notice($inrow);
	 	
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
    //取得参与 需求信息 
	function getJDemands(){
		//参数 最新时间  用于区历史数据用
		$sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_push_m_code,a.demand_from_address,a.demand_to_address,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,b.member_sex,b.member_buyer_pm,a.demand_from_latitudee6,
	     a.demand_from_longitudee6,a.demand_to_latitudee6,a.demand_to_longitudee6,a.demand_reference,a.demand_do_state
	     ,b.member_mobile,a.demand_ct_tel,a.demand_push_m_code ,a.demand_addtime
	     ,c.m_tcount,a.demand_state,c.dtender_state from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount,dtender_state from bc_demand_tender where dtender_state in (0,1) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	 	$sql.= ' where a.demand_code in (select dtender_demand_code  from bc_demand_tender where dtender_m_code= "'.$_REQUEST['m_code'].'" and dtender_state in (0,1,3))';
	 	/*$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" ';
        $sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-3 day')).'%" )';
        $sql.= ' and (a.demand_time like "'.date('Y-m-d').'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+1 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+3 day')).'%" ';
        $sql.= ' or a.demand_time like "'.date('Y-m-d',strtotime('+2 day')).'%" )';*/
	 	if($_REQUEST['d_lasttime'])
	 	   $sql.= ' and date(a.demand_addtime)  < "'.date('Y-m-d H:i:s',str_replace("_", " ", strtotime($_REQUEST['d_lasttime']))).'"';
	 	   //$sql.= ' and a.demand_addtime < "'.strtotime($_REQUEST['d_lasttime']).'" ';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	if($_REQUEST['demand_state']) {
	 		if($_REQUEST['demand_state'] == 1) $sql.= ' and a.demand_state = 0 ';
	 		if($_REQUEST['demand_state'] == 2) $sql.= ' and a.demand_state = 2 ';
	 		if($_REQUEST['demand_state'] == 3) $sql.= ' and ((a.demand_state = 3) or (a.demand_state = 4)) ';
	 	}   
	 	     //1 未选标 2进行中 3 已完成/已取消
	 	     
	 	//$sql.= ' and a.demand_push_m_code <> "'.$_REQUEST['m_code'].'" ';
	 	$sql.= ' order by a.demand_addtime desc ';
	 	$sql.= ' limit 0, 10';
	 	$result = get_info_by_sql($sql);
	 	foreach ($result as $key => $value){
	 		$result[$key]['ft_distance']=GetDistance($value['demand_from_latitudee6'],$value['demand_from_longitudee6'], $value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 2,2);
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' =>$result));
	 	die();
	}
	//取消投标 cancelTender
	function cancelTender(){
		$inrow = array(
	 	    'demand_state'=> 0,
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand($_REQUEST['d_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
		$inrow = array(
	 	    'dtender_state'=> 2,
	 	    'dtender_cancel_by_t_m'=> $_REQUEST['d_cancel'],
	 		'dtender_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand_tender($_REQUEST['d_code'],$_REQUEST['m_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
	//获取需求的详细信息 参与
	function getJDemand(){
	    if($_REQUEST['m_notice']){
	 		$runsql = '';
	 	if($_REQUEST['fn_type'] == 1){
	        $runsql = ' update bc_notice set notice_is_receive = 1 where notice_id ='.$_REQUEST['fn_id'];
		}
	    if($_REQUEST['fn_type'] == 2){
	        $sql = ' select  s_notice_id,s_notice_title,s_notice_content,s_notice_is_receive_code,s_notice_addtime,s_notice_to_m_mobile  from bc_s_notice  ';
	 	    $sql.= ' where s_notice_id ='.$_REQUEST['fn_id'];
	 	    $result = get_info_by_sql($sql);
	        $s_notice_is_receive_code = $result[0]['s_notice_is_receive_code'];
	        if(str_replace($_REQUEST['m_code'], "", $s_notice_is_receive_code)==$s_notice_is_receive_code){
	        	$s_notice_is_receive_code .= ','.$_REQUEST['m_code'];
	        	$runsql = ' update bc_s_notice set s_notice_is_receive_code = "'.$s_notice_is_receive_code.'" where s_notice_id ='.$_REQUEST['fn_id'];
	        }
		}
	    if($runsql != "")run_by_sql($runsql);
	 	}
	 	//wo baojia
	 	$sql = ' select dtender_demand_code,dtender_price from bc_demand_tender  
	 	 where  dtender_demand_code  = "'.$_REQUEST['d_code'].'"   and dtender_state = 1 ';
		$result = get_info_by_sql($sql);
	    //if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	$dtender_price = $result[0]['dtender_price'];
	 	unset($sql,$result);
	 	//
		$sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_from_latitudee6,a.demand_from_longitudee6,
		a.demand_to_address,a.demand_to_latitudee6,a.demand_to_longitudee6,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,b.member_mobile,c.m_tcount,a.demand_d_count,a.demand_d_weight,
	     a.demand_reference,a.demand_ct_name,a.demand_d_price,a.demand_ct_tel,a.demand_d_name,a.demand_state,
	     a.demand_is_baoche,a.demand_ntop_one,a.demand_ntop_two,a.demand_ntop_three,a.demand_do_state
         ,a.demand_reference_maps,a.demand_dh_ntop_one,a.demand_dh_ntop_two,a.demand_dh_ntop_three,a.demand_car_type,
         e.evaluation_content,e.evaluation_servser_pm,e.evaluation_state
	     from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount from bc_demand_tender  where dtender_state in (0,1) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	     $sql.= ' left join (select evaluation_id,evaluation_content,evaluation_servser_pm,evaluation_state,evaluation_d_code
	     from bc_evaluation  ';
	    $sql.= ' where evaluation_to_m_code ="'.$_REQUEST['m_code'].'"  ) as e on e.evaluation_d_code=a.demand_code ';
	    
	 	//$sql.= ' where a.demand_state = 0 ';
	 	//$sql.= ' and a.demand_code not in ( select dtender_demand_code from bc_demand_tender ';
	 	//$sql.= '  where dtender_m_code = "'.$_REQUEST['m_code'].'" )';
	 	//$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" )';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	$sql.= ' where a.demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','demand_p_count' => $result[0]['demand_p_count'],
	 	'demand_from_address' => $result[0]['demand_from_address'],'demand_to_address' => $result[0]['demand_to_address']
	 	,'demand_from_latitudee6' => $result[0]['demand_from_latitudee6'],'demand_from_longitudee6' => $result[0]['demand_from_longitudee6']
	 	,'demand_to_latitudee6' => $result[0]['demand_to_latitudee6'],'demand_to_longitudee6' => $result[0]['demand_to_longitudee6']
	 	,'demand_addtime' => mdate3(strtotime($result[0]['demand_addtime'])),'demand_time' => mdate2(strtotime($result[0]['demand_time'].":00")),
	 	'member_name' => $result[0]['member_name'],'member_logo' => $result[0]['member_logo'],'m_tcount' => $result[0]['m_tcount']
	 	,'demand_d_count' => $result[0]['demand_d_count'],'demand_d_weight' => $result[0]['demand_d_weight']
	 	
	 	,'evaluation_content' => $result[0]['evaluation_content'],'evaluation_servser_pm' => $result[0]['evaluation_servser_pm']
	 	,'evaluation_state' => $result[0]['evaluation_state'],'dt_price' => $dtender_price
	 	
	 	,'demand_reference' => $result[0]['demand_reference'],'demand_ct_name' => $result[0]['demand_ct_name']
	 	,'demand_d_price' => $result[0]['demand_d_price'],'demand_ct_tel' => $result[0]['demand_ct_tel']
	 	,'demand_d_name' => $result[0]['demand_d_name'],'demand_state' => $result[0]['demand_state']
	 	,'demand_is_baoche' => $result[0]['demand_is_baoche'],'demand_ntop_one' => $result[0]['demand_ntop_one'],
	 	'demand_ntop_two' => $result[0]['demand_ntop_two'],'demand_ntop_three' => $result[0]['demand_ntop_three']
	 	,'demand_reference_maps' => $result[0]['demand_reference_maps'],'demand_dh_ntop_one' => $result[0]['demand_dh_ntop_one'],
	 	'demand_dh_ntop_two' => $result[0]['demand_dh_ntop_two'],'demand_dh_ntop_three' => $result[0]['demand_dh_ntop_three']
	 	,'demand_car_type' => $result[0]['demand_car_type'],'demand_do_state' => $result[0]['demand_do_state']
	 	
	 	,'member_mobile' => $result[0]['member_mobile'],'demand_code' => $result[0]['demand_code']
	 	));
	 	die();
	}
	
	//获取需求的详细信息 发布
	function getPDemand(){
		$sql = ' select a.demand_code,a.demand_type,a.demand_p_count,a.demand_from_address,a.demand_to_address,
	     a.demand_addtime,a.demand_time,b.member_name,b.member_logo,c.m_tcount,a.demand_d_count,a.demand_d_weight,
	     a.demand_reference,a.demand_ct_name,a.demand_d_price,a.demand_ct_tel,a.demand_d_name,a.demand_state,
	     d.member_name as z_m_name,d.dtender_price,a.demand_is_baoche,a.demand_ntop_one,a.demand_ntop_two,a.demand_ntop_three
      ,a.demand_reference_maps,a.demand_dh_ntop_one,a.demand_dh_ntop_two,a.demand_dh_ntop_three,a.demand_car_type,
      e.evaluation_content,e.evaluation_buyer_pm,e.evaluation_state
	     from bc_demand a';
	    $sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' left join (select dtender_demand_code,count(dtender_m_code) as m_tcount from bc_demand_tender  where dtender_state in (0,1,3) ';
	    $sql.= ' group by dtender_demand_code ) as c on c.dtender_demand_code=a.demand_code ';
	    $sql.= ' left join (select i.dtender_demand_code,i.dtender_m_code,j.member_name,i.dtender_price from bc_demand_tender i ';
	     $sql.= ' left join bc_member j on i.dtender_m_code = j.member_code ';
	    $sql.= ' where i.dtender_state =1 ) as d on d.dtender_demand_code=a.demand_code ';
	    
	    $sql.= ' left join (select evaluation_id,evaluation_content,evaluation_buyer_pm,evaluation_state,evaluation_d_code
	     from bc_evaluation  ';
	    $sql.= ' where evaluation_to_m_code ="'.$_REQUEST['m_code'].'"  ) as e on e.evaluation_d_code=a.demand_code ';
	    
	 	//$sql.= ' where a.demand_state = 0 ';
	 	//$sql.= ' and a.demand_code not in ( select dtender_demand_code from bc_demand_tender ';
	 	//$sql.= '  where dtender_m_code = "'.$_REQUEST['m_code'].'" )';
	 	//$sql.= ' and (a.demand_addtime like "'.date('Y-m-d').'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-1 day')).'%" ';
        //$sql.= ' or a.demand_addtime like "'.date('Y-m-d',strtotime('-2 day')).'%" )';
        //if($_REQUEST['demand_type'])
	 	//     $sql.= ' and a.demand_type = '.$_REQUEST['demand_type'];
	 	$sql.= ' where a.demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','demand_p_count' => $result[0]['demand_p_count'],
	 	'demand_from_address' => $result[0]['demand_from_address'],'demand_to_address' => $result[0]['demand_to_address']
	 	,'demand_addtime' => mdate3(strtotime($result[0]['demand_addtime'])),'demand_time' => mdate2(strtotime($result[0]['demand_time'].":00")),
	 	'member_name' => $result[0]['member_name'],'member_logo' => $result[0]['member_logo'],'m_tcount' => $result[0]['m_tcount']
	 	,'demand_d_count' => $result[0]['demand_d_count'],'demand_d_weight' => $result[0]['demand_d_weight']
	 	,'evaluation_content' => $result[0]['evaluation_content'],'evaluation_buyer_pm' => $result[0]['evaluation_buyer_pm']
	 	,'evaluation_state' => $result[0]['evaluation_state']
	 	,'demand_reference' => $result[0]['demand_reference'],'demand_ct_name' => $result[0]['demand_ct_name']
	 	,'demand_d_price' => $result[0]['demand_d_price'],'demand_ct_tel' => $result[0]['demand_ct_tel']
	 	,'demand_d_name' => $result[0]['demand_d_name'],'demand_state' => $result[0]['demand_state']
	 	,'z_m_name' => $result[0]['z_m_name'],'dtender_price' => $result[0]['dtender_price'],
	 	'demand_is_baoche' => $result[0]['demand_is_baoche'],'demand_ntop_one' => $result[0]['demand_ntop_one'],
	 	'demand_ntop_two' => $result[0]['demand_ntop_two'],'demand_ntop_three' => $result[0]['demand_ntop_three']
	 	,'demand_reference_maps' => $result[0]['demand_reference_maps'],'demand_dh_ntop_one' => $result[0]['demand_dh_ntop_one'],
	 	'demand_dh_ntop_two' => $result[0]['demand_dh_ntop_two'],'demand_dh_ntop_three' => $result[0]['demand_dh_ntop_three']
	 	,'demand_car_type' => $result[0]['demand_car_type']
	 	));
	 	die();
		
	}
	//完成需求
	function completeDemand(){
		//d_rating d_code d_content
		//时间到了没 验证
		$cnt = 0; 
		$sql = ' select count(demand_code) as cnt  from bc_demand ';
	    $sql.= ' where demand_code= "'.$_REQUEST['d_code'].'"';
	    $sql.= ' and  (UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(demand_time)) ';
	    $result = get_info_by_sql($sql);
	    $cnt = $result[0]['cnt'];
    	if($cnt == 0){
    		echo json_encode(array('state' => 1,'err-code' => 'x002'));
	 	    die();
    	}
    	unset($result,$sql);
	    //发布会员的余额
	    $sql = ' select a.demand_push_m_code,b.member_rmb from bc_demand a ';
		$sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' where a.demand_code= "'.$_REQUEST['d_code'].'"';
	    $result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	//print_R($result);
    	$p_m_rmb = $result[0]['member_rmb'];
    	$p_m_code = $result[0]['demand_push_m_code'];
    	//echo $p_m_rmb;
    	unset($result,$sql);
    	//die();
		//判断内容合法性 d_content
		//echo (float)((5.0+1.3)/2+0.05);
		//member_servser_pm
		
		//获取中标的 会员id
		$sql = 'select a.dtender_demand_code,a.dtender_m_code,a.dtender_sp_code,
		    b.member_servser_pm,b.member_lv,a.dtender_price
           ,b.member_rmb,c.sproduct_is_vip
		  from bc_demand_tender a ';
		$sql.= ' left join bc_member b on a.dtender_m_code = b.member_code ';
		$sql.= ' left join bc_service_product c on a.dtender_sp_code = c.sproduct_code ';
		$sql.= ' where a.dtender_state = 1 ';
	    $sql.= ' and a.dtender_demand_code= "'.$_REQUEST['d_code'].'"';
	    $result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$dtender_m_code = $result[0]['dtender_m_code'];
	 	$member_rmb = $result[0]['member_rmb'];
	 	//$member_lv = $result[0]['member_lv'];
	 	$dtender_price = $result[0]['dtender_price'];
	 	$dtender_sp_code = $result[0]['dtender_sp_code'];
	 	//$sproduct_lv = $result[0]['sproduct_lv'];
	 	$sproduct_is_vip = $result[0]['sproduct_is_vip'];
	 	//$member_servser_pm = $result[0]['member_servser_pm'];
	 	//$member_servser_pm = (($member_servser_pm+$_REQUEST['d_rating'])/2)+0.05;
	 	//echo $member_servser_pm;
	 	unset($result,$sql);
	 	//echo $p_m_rmb,'=',$dtender_price;
	 	//支付方式确认
	 	if($_REQUEST['d_pay_type']==0){
	 		
	 	    if((float)$p_m_rmb < (float)$dtender_price){
	 	    	echo json_encode(array('state' => 1,'err-code' => 'x003'));//余额不足！ 
	 	        die();
	 	    }
	 	}
	 	
	 	//扣点滤
	 	$sql = 'select system_vip_lv,system_id  from bc_system  ';
		
	    $result = get_info_by_sql($sql);
	 	$system_vip_lv = $result[0]['system_vip_lv'];
	 	//
	 	unset($result,$sql);
	     //判断是否 已经添加
    	$cnt = 0;  
    	$sql = ' select count(evaluation_id) as cnt from bc_evaluation ';
	 	$sql.= ' where evaluation_from_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and evaluation_to_m_code = "'.$dtender_m_code.'"';
        $sql.= ' and evaluation_d_code like "'.$_REQUEST['d_code'].'" ';
	 	//$sql.= ' and demand_state = 0 ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt != 0){
    		echo json_encode(array('state' => 1,'err-code' => 'x003'));
	 	    die();
    	}
    	unset($result,$sql);
    	$upinrow = array(
	 		'demand_price'=> $dtender_price,
    	    'demand_state'=> 3,
    	    'demand_pay_type'=> $_REQUEST['d_pay_type'],
	 	);
	    $result = update_demand($_REQUEST['d_code'],$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	$d_rating = $_REQUEST['d_rating'];
	 	if($_REQUEST['d_sts'] == 1)$d_rating=0;
	    $inrow = array(
	 	    'evaluation_from_m_code'=> $_REQUEST['m_code'],
	        'evaluation_to_m_code'=> $dtender_m_code,
	        'evaluation_d_code'=> $_REQUEST['d_code'],
	        'evaluation_content'=> $_REQUEST['d_content'],
	         'evaluation_state'=> $_REQUEST['d_sts'],
	        'evaluation_servser_pm'=> $d_rating,
	 		'evaluation_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_evaluation($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
    	//付款 扣点
    	$d_price=0;
    	$d_price = $member_rmb;
    	if($_REQUEST['d_pay_type']==0){
    		$d_price += $dtender_price;
    		$p_m_rmb -= $dtender_price;
    	}
    	//$d_price =$member_rmb - (($member_lv*$dtender_price)/100);
    	if($sproduct_is_vip == 1)
    	    $d_price =$d_price - (($system_vip_lv*$dtender_price)/100);
	 	if($d_price<0) $d_price=0;
	 	
	 	
    	//客户满意度
    	$sql = ' select avg(evaluation_servser_pm) as pm from bc_evaluation  ';
		$sql.= ' where  evaluation_to_m_code ="'.$_REQUEST['c_m_code'].'"  ';
		$result = get_info_by_sql($sql);
	 	$servser_pm = $result[0]['pm'];
	 	$servser_pm = (($servser_pm+5)/2)+0.05;
    	$upinrow = array(
	 		'member_rmb'=> $d_price,
    	    'member_servser_pm'=> $servser_pm,
	 	);
	 	$result = update_member($dtender_m_code,$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	//发布者
	 	if($_REQUEST['d_pay_type']==0){
	    $upinrow2 = array(
	 		'member_rmb'=> $p_m_rmb,
	 	);
	 	$result = update_member($p_m_code,$upinrow2);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	}
	 	$sql = ' select demand_code,demand_state,demand_push_m_code,demand_type from bc_demand ';
		$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
		$result = get_info_by_sql($sql);
		$demand_type = $result[0]['demand_type'];
		$demand_push_m_code = $result[0]['demand_push_m_code'];
	 	$d_typs = array('','拼车','快递','代驾');
	 	//交易完成通知 
	 	$notcice_ct = '';
	 	if($_REQUEST['d_pay_type']==0){//余额支付
	 	    //线上支付：亲，拼车客户已经在线支付----元并给你评价！请您确认并评价！
	 	    $notcice_ct = '亲，'.$d_typs[$demand_type].'客户已经在线支付'.$dtender_price.'元并给你评价！请您确认并评价！';
	 	}else{//现在支付
	 		//线下支付：亲，拼车客户已经线下支付----元并给你评价！请您确认并评价
	 		$notcice_ct = '亲，'.$d_typs[$demand_type].'客户已经线下支付'.$dtender_price.'元并给你评价！请您确认并评价！';
	 	}
	 	// 'notice_content'=>'亲，关于'.$d_typs[$demand_type].'需求的服务,客户已经确认交易完成并给予评价！您也可以评价客户了，请注意确认！',
	 	$inrow = array(
	 	   'notice_title'=>'交易完成',
	 	   'notice_content'=>$notcice_ct,
	 	   'notice_to_m_code'=>$dtender_m_code,
	 	   'notice_d_code'=>$_REQUEST['d_code'],
	 	   'notice_is_receive'=>0,
	 	   'notice_addtime'=>date('Y-m-d H:i:s'),
	 	);
	 	add_notice($inrow);
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	function pinJia(){
		//获取发布信息 的 会员id
		$sql = 'select a.demand_push_m_code,b.member_buyer_pm
		  from bc_demand a ';
		$sql.= ' left join bc_member b on a.demand_push_m_code = b.member_code ';
	    $sql.= ' where a.demand_code= "'.$_REQUEST['d_code'].'"';
	    $result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$demand_push_m_code = $result[0]['demand_push_m_code'];
	 	$member_buyer_pm = $result[0]['member_buyer_pm'];
	 	unset($result,$sql);
	     //判断是否 已经添加
    	$cnt = 0;  
    	$sql = ' select count(evaluation_id) as cnt from bc_evaluation ';
	 	$sql.= ' where evaluation_from_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and evaluation_to_m_code = "'.$demand_push_m_code.'"';
        $sql.= ' and evaluation_d_code = "'.$_REQUEST['d_code'].'" ';
	 	//$sql.= ' and demand_state = 0 ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt != 0){
    		echo json_encode(array('state' => 1,'err-code' => 'x003'));
	 	    die();
    	}
    	
	  
    	unset($result,$sql);
    	$d_rating = $_REQUEST['d_rating'];
	 	if($_REQUEST['d_sts'] == 1)$d_rating=0;
	    $inrow = array(
	 	    'evaluation_from_m_code'=> $_REQUEST['m_code'],
	        'evaluation_to_m_code'=> $demand_push_m_code,
	        'evaluation_d_code'=> $_REQUEST['d_code'],
	        'evaluation_content'=> $_REQUEST['d_content'],
	       'evaluation_state'=> $_REQUEST['d_sts'],
	        'evaluation_buyer_pm'=> $d_rating,
	 		'evaluation_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_evaluation($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	 //客户满意度
    	$sql = ' select avg(evaluation_buyer_pm) as pm from bc_evaluation  ';
		$sql.= ' where  evaluation_to_m_code ="'.$_REQUEST['c_m_code'].'"  ';
		$result = get_info_by_sql($sql);
	 	$evaluation_buyer_pm = $result[0]['pm'];
	 	$evaluation_buyer_pm = (($evaluation_buyer_pm+5)/2)+0.05;
    	$upinrow = array(
    	    'member_buyer_pm'=> $evaluation_buyer_pm,
	 	);
	 	$result = update_member($demand_push_m_code,$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	 	
	}
	//取消需求
	function cancelDemand(){
	    //判断是否 无法取消需求
		$sql = ' select demand_code,demand_state from bc_demand ';
		$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
		$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$demand_state = $result[0]['demand_state'];
		if($demand_state > 2){
			echo json_encode(array('state' => 1,'err-code' => 'x002'));
	 	    die();
		}
		
		$inrow = array(
	 	    'demand_state'=> 4,
	 	    'demand_cancel_reference'=> $_REQUEST['d_cancel'],
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand($_REQUEST['d_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//获取需求的详细信息 修改
	function getDemandForEdit(){
		$sql = ' select demand_code,demand_type,demand_p_count,demand_from_address,demand_to_address,
	     demand_addtime,demand_time,demand_d_count,demand_d_weight,demand_reference,demand_ct_name,
	     demand_d_price,demand_ct_tel,demand_d_name,demand_state,demand_from_latitudee6,demand_to_latitudee6,
	     demand_from_longitudee6,demand_to_longitudee6 ,demand_is_baoche,demand_ntop_one,demand_ntop_two,demand_ntop_three
	     ,demand_reference_maps,demand_car_type,demand_dh_ntop_one,demand_dh_ntop_two,demand_dh_ntop_three
	     from bc_demand  ';
	   
	 	$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','demand_p_count' => $result[0]['demand_p_count'],
	 	'demand_from_address' => $result[0]['demand_from_address'],'demand_to_address' => $result[0]['demand_to_address']
	 	,'demand_addtime' => mdate3(strtotime($result[0]['demand_addtime'])),'demand_time' => $result[0]['demand_time'],
	 	'demand_show_time' => mdate2(strtotime($result[0]['demand_time'].":00")),
	 	'demand_from_latitudee6' => $result[0]['demand_from_latitudee6'],'demand_to_latitudee6' => $result[0]['demand_to_latitudee6'],
	 	'demand_d_count' => $result[0]['demand_d_count'],'demand_d_weight' => $result[0]['demand_d_weight']
	 	
	 	,'demand_reference' => $result[0]['demand_reference'],'demand_ct_name' => $result[0]['demand_ct_name']
	 	,'demand_d_price' => $result[0]['demand_d_price'],'demand_ct_tel' => $result[0]['demand_ct_tel']
	 	,'demand_d_name' => $result[0]['demand_d_name'],'demand_state' => $result[0]['demand_state']
	 	,'demand_from_longitudee6' => $result[0]['demand_from_longitudee6'],'demand_to_longitudee6' => $result[0]['demand_to_longitudee6']
	 	
	 	,'demand_is_baoche' => $result[0]['demand_is_baoche'],'demand_ntop_one' => $result[0]['demand_ntop_one']
	 	,'demand_ntop_two' => $result[0]['demand_ntop_two'],'demand_ntop_three' => $result[0]['demand_ntop_three']
	 	,'demand_reference_maps' => $result[0]['demand_reference_maps']
	 	,'demand_car_type' => $result[0]['demand_car_type'],'demand_dh_ntop_one' => $result[0]['demand_dh_ntop_one']
	 	,'demand_dh_ntop_two' => $result[0]['demand_dh_ntop_two'],'demand_dh_ntop_three' => $result[0]['demand_dh_ntop_three']
	 	));
	 	die();
	}
	
	
	//获取投标的详细信息 商家列表
	function getTenderMemberList(){
	    $sql = ' select a.demand_code,a.demand_state,a.demand_push_m_code,b.member_latitudee6,b.member_longitudee6 
	     ,a.demand_type from bc_demand a ';
	    $sql.= ' left join bc_member  b on a.demand_push_m_code=b.member_code ';
	 	$sql.= ' where a.demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$demand_state = $result[0]['demand_state'];
	 	$demand_push_m_code = $result[0]['demand_push_m_code'];
	 	$member_latitudee6 = $result[0]['member_latitudee6'];
	 	$member_longitudee6 = $result[0]['member_longitudee6'];
	 	
	 	$demand_type = $result[0]['demand_type'];
	 	unset($sql,$result);
	    $sql = ' select a.dtender_m_code,a.dtender_price,a.dtender_state,b.member_name,b.member_logo,a.dtender_reference
	    ,b.member_servser_pm,b.member_buyer_pm,b.member_about,b.member_latitudee6,b.member_longitudee6,b.member_jz_date,
	    b.member_loc_share,b.member_sex
	      from bc_demand_tender a ';
	    $sql.= ' left join bc_member  b on a.dtender_m_code=b.member_code ';
	 	$sql.= ' where a.dtender_demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$sql.= ' and a.dtender_state in (0,1,3) ';
	 	$sql.= ' order by a.dtender_state <> 1 asc ';
	 	if($_REQUEST['data_type'] == 2)$sql.= ', a.dtender_price asc ';
	 	if($_REQUEST['data_type'] == 3)$sql.= ', b.member_servser_pm desc ';
	 	$result = get_info_by_sql($sql);
	    $m_juli = array();$list = array();
	    $tmp_array=array();
	    $tmp_m_code="";
	    foreach ($result as $key => $value){
	    	if($value['dtender_state']==1)$tmp_m_code=$value['dtender_m_code'];
	    	
	    	$result[$key]['m_juli'] = "";
	    	if($value['member_loc_share'] == 0){	    	
	 	        $result[$key]['m_juli'] = GetDistance($member_latitudee6,$member_longitudee6, $value['member_latitudee6'],$value['member_longitudee6'], 2,2);
	    	    $m_juli[] = $result[$key]['m_juli'];
	    	}else{
	    		$result[$key]['m_juli'] =9999999999999999;
	    		$m_juli[] = 9999999999999999;
	    	}
	 	    
	        //身份认证
		    $rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		    $cnt = 0;
	 	    $sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$value['dtender_m_code'].'"';
	 	    $result_0 = get_info_by_sql($sql);
	 	    $cnt = $result_0[0]['cnt'];
	 	    unset($result_0,$sql);
	 	    if($cnt == 0){
	 		    $rz_idcard = 0;
	 	    }else{
	 	        $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	        $sql.= ' where ic_auth_m_code ="'.$value['dtender_m_code'].'"';
	 	        $result_1 = get_info_by_sql($sql);
	 	        $ic_auth_state= $result_1[0]['ic_auth_state'];
	 	        $rz_idcard = (int)$ic_auth_state+1;
	 	    }
	 	    $result[$key]['m_rz_idcard'] = $rz_idcard;
	 	    $m_jr = "";
	 	    if($demand_type == 3){
	 	        $jl_cnt = 0;
	 	        $member_jz_date = $value['member_jz_date'];
	 	        if($member_jz_date == null){
	 		        $jl_cnt = 0;
	 	        }else{
	 		        $jl_cnt =getMonthNum($member_jz_date,date('Y-m-d'));
	 		        $m_jr = driverOld3($jl_cnt)."";
	 	        }
	 	        
	 	    }
	 	    $result[$key]['m_jr'] = $m_jr;
	 	}
	 	$tmp_array =$result[0];
	 	if($_REQUEST['data_type'] == 1)
	 	     array_multisort($m_juli, $result);
	 	if($demand_state==2){
	 		$list[] = $tmp_array;
	 		foreach ($result as $key => $value){
	 			if($value['dtender_m_code']==$tmp_m_code)continue;
	 			$list[] = $value;
	 		}
	 	}else{
	 		$list = $result;
	 	}
	 	
	    //foreach ($result as $key => $value){
	 	//	$result[$key]['ft_distance']=GetDistance($value['demand_from_latitudee6'],$value['demand_from_longitudee6'], $value['demand_to_latitudee6'],$value['demand_to_longitudee6'], 2,2);
	 	//}
	 	if($_REQUEST['m_notice']){
	 		$runsql = '';
	 	if($_REQUEST['fn_type'] == 1){
	        $runsql = ' update bc_notice set notice_is_receive = 1 where notice_id ='.$_REQUEST['fn_id'];
		}
	    if($_REQUEST['fn_type'] == 2){
	        $sql = ' select  s_notice_id,s_notice_title,s_notice_content,s_notice_is_receive_code,s_notice_addtime,s_notice_to_m_mobile  from bc_s_notice  ';
	 	    $sql.= ' where s_notice_id ='.$_REQUEST['fn_id'];
	 	    $result = get_info_by_sql($sql);
	        $s_notice_is_receive_code = $result[0]['s_notice_is_receive_code'];
	        if(str_replace($_REQUEST['m_code'], "", $s_notice_is_receive_code)==$s_notice_is_receive_code){
	        	$s_notice_is_receive_code .= ','.$_REQUEST['m_code'];
	        	$runsql = ' update bc_s_notice set s_notice_is_receive_code = "'.$s_notice_is_receive_code.'" where s_notice_id ='.$_REQUEST['fn_id'];
	        }
		}
	    if($runsql != "")run_by_sql($runsql);
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list,
	 	'demand_state' => $demand_state,'demand_type' => $demand_type));
	 	die();
	}
	//选标
	function selectTender(){
		$inrow = array(
	 	    'demand_state'=> 2,
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand($_REQUEST['d_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	$uprow = array(
	 	    'dtender_state'=> 1,
	 	
	 		'dtender_gettime'=> date('Y-m-d H:i:s'),
	 		);
	    $result = update_demand_tender($_REQUEST['d_code'],$_REQUEST['d_m_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$sql = ' select demand_code,demand_type from bc_demand  ';
	    //$sql.= ' left join bc_demand  b on b.demand_code=a.dtender_demand_code ';
	 	$sql.= ' where demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$result = get_info_by_sql($sql);
	 	$demand_type =$result[0]['demand_type'];
	 	$d_typs = array('','拼车','快递','代驾');
	 	//中标通知
	 	$inrow = array(
	 	   'notice_title'=>'中标',
	 	   'notice_content'=>'亲，您参与投标的'.$d_typs[$demand_type].'需求，您中标了！请注意查看！',
	 	   'notice_to_m_code'=>$_REQUEST['d_m_code'],
	 	   'notice_d_code'=>$_REQUEST['d_code'],
	 	   'notice_is_receive'=>0,
	 	   'notice_addtime'=>date('Y-m-d H:i:s'),
	 	);
	 	add_notice($inrow);
	 	
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//选标 取消
	function cancelSelectTender(){
	    
	    $inrow = array(
	 	    'demand_state'=> 0,
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand($_REQUEST['d_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	$uprow = array(
	 	    'dtender_state'=> 3,
	 	    'dtender_cancel_by_p_m'=> $_REQUEST['d_cancel'],
	 		'dtender_gettime'=> date('Y-m-d H:i:s'),
	 		);
	    $result = update_demand_tender($_REQUEST['d_code'],$_REQUEST['d_m_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//选标 取消2
	function cancelSelectTender2(){
		$sql = ' select dtender_m_code,dtender_state from bc_demand_tender  ';
	 	$sql.= ' where dtender_demand_code = "'.$_REQUEST['d_code'].'" ';
	 	$sql.= ' and dtender_state = 1 ';
	 	$result = get_info_by_sql($sql);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$dtender_m_code = $result[0]['dtender_m_code'];
	 	unset($result,$sql);
		$inrow = array(
	 	    'demand_state'=> 0,
	 		'demand_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_demand($_REQUEST['d_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	unset($result);
	 	$uprow = array(
	 	    'dtender_state'=> 3,
	 	    'dtender_cancel_by_p_m'=> $_REQUEST['d_cancel'],
	 		'dtender_gettime'=> date('Y-m-d H:i:s'),
	 		);
	    $result = update_demand_tender($_REQUEST['d_code'],$dtender_m_code,$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//获取商家信息
	function getSMember(){
		$sql = ' select a.member_logo,a.member_name,a.member_mobile,a.member_latitudee6,a.member_longitudee6,
		b.sa_latitudee6,b.sa_longitudee6,a.member_servser_pm,a.member_buyer_pm,a.member_sex,a.member_birthday,
		a.member_signature,a.member_profession,a.member_about,a.member_sale_area,a.member_company_web,
		a.member_jz_type,a.member_jz_date,a.member_car_type,a.member_car_t_date,a.member_company,
		a.member_company_type,a.member_company_address ,a.member_car_t_bx,a.member_cardcode
		  from bc_member a ';
		$sql.= ' left join bc_shop_address b on a.member_code=b.sa_m_code';
	 	$sql.= ' where a.member_code ="'.$_REQUEST['s_m_code'].'"';
	 	$result_mm = get_info_by_sql($sql);
	 	if(false === $result_mm){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	    //身份认证 
		$rz_idcard = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ic_auth_m_code) as cnt from bc_idcard_auth ';
	 	$sql.= ' where ic_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_idcard = 0;
	 	}else{
	 	    $sql = ' select ic_auth_state,ic_auth_m_code from bc_idcard_auth ';
	 	    $sql.= ' where ic_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ic_auth_state= $result[0]['ic_auth_state'];
	 	    $rz_idcard = (int)$ic_auth_state+1;
	 	}
	 	//驾照认证
	    $rz_driver = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(dr_auth_m_code) as cnt from bc_driver_auth ';
	 	$sql.= ' where dr_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_driver = 0;
	 	}else{
	 	    $sql = ' select dr_auth_state,dr_auth_m_code from bc_driver_auth ';
	 	    $sql.= ' where dr_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $dr_auth_state= $result[0]['dr_auth_state'];
	 	    $rz_driver = (int)$dr_auth_state+1;
	 	}
	 	$jl_cnt = 0;
	 	$member_jz_date = $result_mm[0]['member_jz_date'];
	 	if($member_jz_date == null){
	 		$jl_cnt = 0;
	 	}else{
	 		$jl_cnt =getMonthNum($member_jz_date,date('Y-m-d'));
	 	}
	 	$car_t_date = 0;
	 	$member_car_t_date = $result_mm[0]['member_car_t_date'];
	     if($member_jz_date == null){
	 		$car_t_date = 0;
	 	}else{
	 		$car_t_date =getMonthNum($member_car_t_date,date('Y-m-d'));
	 	}
	 	
	 	//公司信息认证
	    $rz_company = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(cy_auth_m_code) as cnt from bc_company_auth ';
	 	$sql.= ' where cy_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_company = 0;
	 	}else{
	 	    $sql = ' select cy_auth_state,cy_auth_m_code from bc_company_auth ';
	 	    $sql.= ' where cy_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $cy_auth_state= $result[0]['cy_auth_state'];
	 	    $rz_company = (int)$cy_auth_state+1;
	 	}
	     //车型信息认证
	    $rz_cartype = 0;//0 未申请 1 申请未审核 2 审核通过 3 审核失败
		$cnt = 0;
	 	$sql = ' select count(ct_auth_m_code) as cnt from bc_cartype_auth ';
	 	$sql.= ' where ct_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	unset($result,$sql);
	 	if($cnt == 0){
	 		$rz_cartype = 0;
	 	}else{
	 	    $sql = ' select ct_auth_state,ct_auth_m_code from bc_cartype_auth ';
	 	    $sql.= ' where ct_auth_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	    $result = get_info_by_sql($sql);
	 	    $ct_auth_state= $result[0]['ct_auth_state'];
	 	    $rz_cartype = (int)$ct_auth_state+1;
	 	}
	 	unset($result,$sql);
	 	
	 	
	 	
	 	//店铺地址信息
	 	$shop_address = '';
	 	$sql = ' select sa_m_code,sa_address from bc_shop_address ';
	 	$sql.= ' where sa_m_code ="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$shop_address = $result[0]['sa_address'];
	 	if($shop_address == null)$shop_address = '';
	 	//是否朋友关系 或者已经申请
	 	$isfd = 0;//默认不是
	     $cnt = 0;
	 	$sql = ' select count(friends_id) as cnt from bc_friends ';
	 	$sql.= ' where ((friends_r_m_code ="'.$_REQUEST['s_m_code'].'"';
	 	$sql.= ' and friends_l_m_code = "'.$_REQUEST['m_code'].'")';
	 	$sql.= ' or (friends_r_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and friends_l_m_code = "'.$_REQUEST['s_m_code'].'"))';
	 	$sql.= ' and friends_state <> 2 ';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0)$isfd = 1;
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','m_logo' => $result_mm[0]['member_logo'],
	 	'm_name' => $result_mm[0]['member_name'],'m_mobile' => $result_mm[0]['member_mobile'],'m_latitudee6' => $result_mm[0]['member_latitudee6']
	 	,'m_longitudee6' => $result_mm[0]['member_longitudee6'],'s_latitudee6' => $result_mm[0]['sa_latitudee6'],'s_longitudee6' => $result_mm[0]['sa_longitudee6']
	 	,'m_servser_pm' => $result_mm[0]['member_servser_pm'],'m_buyer_pm' => $result_mm[0]['member_buyer_pm']
	 	,'m_sex' => $result_mm[0]['member_sex'],'m_birthday' => $result_mm[0]['member_birthday'],'m_signature' => $result_mm[0]['member_signature']
	 	,'m_profession' => $result_mm[0]['member_profession'],'m_about' => $result_mm[0]['member_about'],'m_cardcode'=>$result_mm[0]['member_cardcode']
	 	,'m_rz_idcard'=>$rz_idcard,'m_rz_driver'=>$rz_driver,'m_rz_company'=>$rz_company,'m_rz_cartype'=>$rz_cartype
	 	,'m_sale_area'=>$result_mm[0]['member_sale_area'],'m_company_web'=>$result_mm[0]['member_company_web']
	 	,'m_shop_address'=>$shop_address,'m_isfd'=>$isfd,'m_jz_type'=>$result_mm[0]['member_jz_type']
	 	,'m_jz_jr'=>driverOld($jl_cnt),'m_car_type'=>$result_mm[0]['member_car_type'],'m_car_t_date'=>driverOld2($car_t_date)
	 	,'m_company'=>$result_mm[0]['member_company'],'m_company_type'=>$result_mm[0]['member_company_type']
	 	,'m_company_address'=>$result_mm[0]['member_company_address'],'m_car_t_bx'=>$result_mm[0]['member_car_t_bx']
	 	));
	 	die();
	}
	//notice
	function getNotice(){
		$runsql = '';$notice_title="";
		$notice_content="";
		if($_REQUEST['n_type'] == 1){
			$sql = ' select  notice_id,notice_title,notice_content,notice_is_receive,notice_addtime,notice_to_m_code  from bc_notice  ';
	 	    $sql.= ' where notice_id ='.$_REQUEST['n_id'];
	        $result = get_info_by_sql($sql);
	        $notice_title = $result[0]['notice_title'];
	        $notice_content = $result[0]['notice_content'];
	        $runsql = ' update bc_notice set notice_is_receive = 1 where notice_id ='.$_REQUEST['n_id'];
		}
	    if($_REQUEST['n_type'] == 2){
	        $sql = ' select  s_notice_id,s_notice_title,s_notice_content,s_notice_is_receive_code,s_notice_addtime,s_notice_to_m_mobile  from bc_s_notice  ';
	 	    $sql.= ' where s_notice_id ='.$_REQUEST['n_id'];
	 	    $result = get_info_by_sql($sql);
	        $notice_title = $result[0]['s_notice_title'];
	        $notice_content = $result[0]['s_notice_content'];
	        
	        $s_notice_is_receive_code = $result[0]['s_notice_is_receive_code'];
	        if(str_replace($_REQUEST['m_code'], "", $s_notice_is_receive_code)==$s_notice_is_receive_code){
	        	$s_notice_is_receive_code .= ','.$_REQUEST['m_code'];
	        	$runsql = ' update bc_s_notice set s_notice_is_receive_code = "'.$s_notice_is_receive_code.'" where s_notice_id ='.$_REQUEST['n_id'];
	        }
		}
	    
	    if($runsql != "")run_by_sql($runsql);
	    echo json_encode(array('state' => 0,'err-code' => '','n_title' => $notice_title,'n_content' => $notice_content));
	 	die();
	}
    function getNoticeByother(){
		$runsql = '';
		
        if($_REQUEST['m_notice']){
	 		$runsql = '';
	        $runsql = ' update bc_notice set notice_is_receive = 1 where notice_id ='.$_REQUEST['fn_id'];
	        if($runsql != "")run_by_sql($runsql);
	 	}
	 	
	 	$sql = ' select demand_code,demand_state,demand_ok_state,demand_p_map from bc_demand ';
	 	$sql.= ' where demand_code ="'.$_REQUEST['d_code'].'"';
	 	$result = get_info_by_sql($sql);
       // if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	$demand_ok_state = $result[0]['demand_ok_state'];
	 	$demand_p_map = $result[0]['demand_p_map'];
	 	$demand_state = $result[0]['demand_state'];
	 	
	    echo json_encode(array('state' => 0,'err-code' => '','d_ok_state' => $demand_ok_state
	    ,'d_state' => $demand_state,'d_p_map' => $demand_p_map));
	 	die();
	}
    
	//获取chats 打开对话界面时 三条记录
	function getChatLogByStart(){
	    $sql = ' select * from (select  a.chats_id, a.chats_content, a.chats_to_m_code, a.chats_from_m_code, a.chats_addtime  
	     ,b.member_name as from_m_name,b.member_logo as from_m_logo
	       from bc_chats a ';
	    //$sql.= ' left join  bc_member b on a.chats_to_m_code=b.member_code ';
	    $sql.= ' left join  bc_member b on a.chats_from_m_code=b.member_code ';
	 	$sql.= ' where ( a.chats_to_m_code ="'.$_REQUEST['c_m_code'].'"';
	 	$sql.= ' and  a.chats_from_m_code ="'.$_REQUEST['m_code'].'" )';
	 	$sql.= ' or ( a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and  a.chats_from_m_code ="'.$_REQUEST['c_m_code'].'" )';
	 	$sql.= ' order by  a.chats_addtime desc ';
	 	$sql.= ' limit 0,3) as ii  order by ii.chats_addtime asc ';
	 	$result = get_info_by_sql($sql);
	     $m_cds = '';
	 	foreach ($result as $key=> $value){
	 		if($value['chats_to_m_code'] == $_REQUEST['m_code']){
	 		if($m_cds != '')$m_cds.=',';
	 		$m_cds.=$value['chats_id'];}
	 	}
	 	unset($sql);
	 	if($m_cds != ''){
	 	    $sql = ' update bc_chats set chats_is_receive = 1 where chats_id in ('.$m_cds.')';
	 	    run_by_sql($sql);
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//获取对话记录 每个五秒读取一次
	function getChatLog(){
		$sql = ' select * from ( select  a.chats_id, a.chats_content, a.chats_to_m_code, a.chats_from_m_code, a.chats_addtime  
	     ,b.member_name as from_m_name,b.member_logo as from_m_logo
	       from bc_chats a ';
	    //$sql.= ' left join  bc_member b on a.chats_to_m_code=b.member_code ';
	    $sql.= ' left join  bc_member b on a.chats_from_m_code=b.member_code ';
	 	$sql.= ' where (( a.chats_to_m_code ="'.$_REQUEST['c_m_code'].'"';
	 	$sql.= ' and  a.chats_from_m_code ="'.$_REQUEST['m_code'].'" )';
	 	$sql.= ' or ( a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and  a.chats_from_m_code ="'.$_REQUEST['c_m_code'].'" ))';
	 	//$sql.= ' and  a.chats_addtime > "'.$_REQUEST['c_addtime'].'" ';
	 	$sql.= ' and unix_timestamp(a.chats_addtime) > unix_timestamp("'.str_replace("_", " ",$_REQUEST['c_addtime']).'")';
	 	$sql.= ' order by  a.chats_addtime desc ';
	 	if(!$_REQUEST['c_addtime'])$sql.= ' limit 0,3';
	 	$sql.= ') as ii order by ii.chats_addtime asc ';
	 	
	 	$result = get_info_by_sql($sql);
	 	$m_cds = '';
	 	foreach ($result as $key=> $value){
	 		if($value['chats_to_m_code'] == $_REQUEST['m_code']){
	 		if($m_cds != '')$m_cds.=',';
	 		$m_cds.=$value['chats_id'];}
	 	}
	 	unset($sql);
	 	if($m_cds != ''){
	 	    $sql = ' update bc_chats set chats_is_receive = 1 where chats_id in ('.$m_cds.')';
	 	    run_by_sql($sql);
	 	}
	 	
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//发送对话记录
	function sendChat(){
	 	$addtime = date('Y-m-d H:i:s');
	 	$inrow = array(
	 		'chats_content'=> $_REQUEST['to_content'],
	 		'chats_from_m_code'=> $_REQUEST['m_code'],
	 	    'chats_to_m_code'=> $_REQUEST['to_m_code'],
	 	    'chats_is_receive'=> 0,
	 		'chats_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_chat($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','add_time' =>$addtime));
	 	die();
	}
	//获取评价
	function getEvaluations(){
		$sql = ' select a.evaluation_content, a.evaluation_addtime, a.evaluation_id,
		b.member_name as from_m_name,b.member_logo as from_m_logo,a.evaluation_servser_pm,c.demand_type
	       from bc_evaluation a ';
	    $sql.= ' left join  bc_member b on a.evaluation_from_m_code=b.member_code ';
	    $sql.= ' left join  bc_demand c on a.evaluation_d_code=c.demand_code ';
		$sql.= ' where a.evaluation_to_m_code ="'.$_REQUEST['c_m_code'].'"';
		$sql.= ' and c.demand_push_m_code <> "'.$_REQUEST['c_m_code'].'"  ';
		$sql.= ' limit 0,20 ';
		$result = get_info_by_sql($sql);
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//vip
	function addApplyVip(){
	    $cnt = 0;
	 	$sql = ' select count(vip_apply_id) as cnt from bc_vip_sproduct_apply ';
	 	$sql.= ' where vip_apply_sp_code ="'.$_REQUEST['sp_code'].'"';
	 	$sql.= ' and vip_apply_state <> 2 ';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
	 	    die();
	 	}
	 	$inrow = array(
	 		'vip_apply_sp_code'=> $_REQUEST['sp_code'],
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_vip_sproduct_apply($inrow);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//商品上下驾
	function upSpState(){
		$inrow = array(
	 		'sproduct_state'=> $_REQUEST['sp_l_type'],
	 		'sproduct_uptime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = update_service_product($_REQUEST['sp_code'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//获取拼车商品
	function getSPPCData(){
		$sql = ' select at_id,at_name from bc_address_type ';
	 	$sql.= ' where at_m_code = "'.$_REQUEST['m_code'].'" and at_isdel = 0 ';
	 	$result_at = get_info_by_sql($sql);
	 	//if(false === $result_at){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	unset($sql);
	 	 $sql = '';
	 	 if(false === $result_at){
	 	 	$sql = ' select a.*,null as from_at_name,null as to_at_name  from bc_service_product a ';
	        //$sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	        //$sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	    $sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	    $result_at = array();
	 	 }else{
	        $sql = ' select a.*,b.at_name as from_at_name,c.at_name as to_at_name  from bc_service_product a ';
	        $sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	        $sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	    $sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	 }
	 	$result = get_info_by_sql($sql);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_p_price' => $result[0]['sproduct_p_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	  'from_at_name' =>$result[0]['from_at_name'], 'to_at_name' => $result[0]['to_at_name'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference'],'sp_m_code' => $result[0]['sproduct_m_code'],
	 	'sp_price_set' => $result[0]['sproduct_pc_price_set']
	 	,'sp_price_one' => $result[0]['sproduct_pc_price_one'],'sp_price_bc' => $result[0]['sproduct_pc_price_bc']
	 	,'sp_price_two' => $result[0]['sproduct_pc_price_two'],'sp_price_two_bc' => $result[0]['sproduct_pc_price_two_bc']
	 	,'sp_price_three' => $result[0]['sproduct_pc_price_three'],'sp_price_three_bc' => $result[0]['sproduct_pc_price_three_bc']
	 	,'sp_price_four' => $result[0]['sproduct_pc_price_four'],'sp_price_four_bc' => $result[0]['sproduct_pc_price_four_bc']
	 	,'sp_price_f_t' => $result[0]['sproduct_pc_price_f_t'],'sp_price_f_t_bc' => $result[0]['sproduct_pc_price_f_t_bc']
	 	,'sp_price_tmore' => $result[0]['sproduct_pc_price_tmore'],'sp_price_tmore_bc' => $result[0]['sproduct_pc_price_tmore_bc']
	 	,'sp_is_vip' => $result[0]['sproduct_is_vip']
	 	
	 	 ));
	 	die();
	}
	
    //修改拼车服务商品
    function editSPPinche(){
        if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
        //if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
	   // if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and sproduct_code <> "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
	 	
	 	
	 	
		//$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$upinrow = array(
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    'sproduct_p_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	    'sproduct_pc_price_set'=> (int)$_REQUEST['m_sp_price_set'],
	 	    'sproduct_pc_price_one'=> $_REQUEST['m_sp_price_one'],
	 	    'sproduct_pc_price_bc'=> $_REQUEST['m_sp_price_bc'],
	 	    'sproduct_pc_price_two'=> $_REQUEST['m_sp_price_two'],
	 	   // 'sproduct_pc_price_two_bc'=> $_REQUEST['m_sp_price_two_bc'],
	 	    'sproduct_pc_price_three'=> $_REQUEST['m_sp_price_three'],
	 	   // 'sproduct_pc_price_three_bc'=> $_REQUEST['m_sp_price_three_bc'],
	 	    'sproduct_pc_price_four'=> $_REQUEST['m_sp_price_four'],
	 	   // 'sproduct_pc_price_four_bc'=> $_REQUEST['m_sp_price_four_bc'],
	 	
	 	   // 'sproduct_pc_price_f_t'=> $_REQUEST['m_sp_price_f_t'],
	 	   // 'sproduct_pc_price_f_t_bc'=> $_REQUEST['m_sp_price_f_t_bc'],
	 	   // 'sproduct_pc_price_tmore'=> $_REQUEST['m_sp_price_tmore'],
	 	   // 'sproduct_pc_price_tmore_bc'=> $_REQUEST['m_sp_price_tmore_bc'],
	 	);
	 	$result = update_service_product($_REQUEST['m_sp_code'],$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	$sql = ' select vip_apply_state,vip_apply_sp_code  from bc_vip_sproduct_apply  ';
	 	$sql.= ' where vip_apply_sp_code = "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$vip_apply_state = $result[0]['vip_apply_state'];
        if($vip_apply_state <> 0){
	 	    $inrow2 = array(
	 		'vip_apply_sp_code'=> $_REQUEST['m_sp_code'],
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	    );
	 	    $result = update_vip_sproduct_apply2($_REQUEST['m_sp_code'],$inrow2);
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
    }
    //获取代驾商品
	function getSPDJData(){
		$sql = ' select at_id,at_name from bc_address_type ';
	 	$sql.= ' where at_m_code = "'.$_REQUEST['m_code'].'" and at_isdel=0 ';
	 	$result_at = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	   // echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	   // die();
	 	}
	 	unset($sql);
	 	$sql = '';
	 	if(false === $result_at){
	 	$sql = ' select a.*,null as from_at_name,null as to_at_name  from bc_service_product a ';
	   
	   // $sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	    //$sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	$result_at = array();
	 	}else{
	    $sql = ' select a.*,b.at_name as from_at_name,c.at_name as to_at_name  from bc_service_product a ';
	   
	    $sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	    $sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';}
	 	$result = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_dr_price' => $result[0]['sproduct_dr_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	 'from_at_name' => $result[0]['from_at_name'], 'to_at_name' => $result[0]['to_at_name'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference'],'sp_is_vip' => $result[0]['sproduct_is_vip']
	 	 ));
	 	die();
	}
	//代驾商品
	function editSPDaijia(){
		if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
        if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and sproduct_code <> "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
		//$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$upinrow = array(
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    'sproduct_dr_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	);
	 	$result = update_service_product($_REQUEST['m_sp_code'],$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	    $sql = ' select vip_apply_state,vip_apply_sp_code  from bc_vip_sproduct_apply  ';
	 	$sql.= ' where vip_apply_sp_code = "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$vip_apply_state = $result[0]['vip_apply_state'];
        if($vip_apply_state <> 0){
	 	    $inrow2 = array(
	 		'vip_apply_sp_code'=> $_REQUEST['m_sp_code'],
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	    );
	 	    $result = update_vip_sproduct_apply2($_REQUEST['m_sp_code'],$inrow2);
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
	
   //获取带货商品
	function getSPDHData(){
		$sql = ' select at_id,at_name from bc_address_type ';
	 	$sql.= ' where at_m_code = "'.$_REQUEST['m_code'].'" and at_isdel=0 ';
	 	$result_at = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    //echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    //die();
	 	}
	 	unset($sql);
	 	$sql = ' ';
	 	if(false === $result_at){
	 		$sql = ' select a.*,null as from_at_name,null as to_at_name  from bc_service_product a ';
	    //$sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	    //$sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	    $sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	    $result_at = array();
	 	}else{
	 		$sql = ' select a.*,b.at_name as from_at_name,c.at_name as to_at_name  from bc_service_product a ';
	   
	    $sql.= 'left join bc_address_type b on a.sproduct_from_at_id=b.at_id ';
	    $sql.= 'left join bc_address_type c on a.sproduct_to_at_id=c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	}
	   
	 	$result = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_d_price' => $result[0]['sproduct_d_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	 'from_at_name' => $result[0]['from_at_name'], 'to_at_name' => $result[0]['to_at_name'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference']
	 	,'sp_price_set' => $result[0]['sproduct_dh_price_set'],'sp_is_vip' => $result[0]['sproduct_is_vip']
	 	,'sp_price_one' => $result[0]['sproduct_dh_price_one'],'sp_price_four' => $result[0]['sproduct_dh_price_four']
	 	,'sp_price_two' => $result[0]['sproduct_dh_price_two'],'sp_price_five' => $result[0]['sproduct_dh_price_five']
	 	,'sp_price_three' => $result[0]['sproduct_dh_price_three'],'sp_price_six' => $result[0]['sproduct_dh_price_six']
	 	 ));
	 	die();
	}
    //带货商品
	function editSPDaihuo(){
		if(!$_REQUEST['m_sp_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
       // if(!isset($_REQUEST['m_sp_price'])){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
	   // if(isset($_REQUEST['m_sp_price']) and ($_REQUEST['m_sp_price'] == '')){	//参数m_sex 不能为空
		//	echo json_encode(array('state' => 1,'err-code' => 'x003')); 
		//	die();
		//}
		
        if($_REQUEST['m_sp_qunhao']){	
        	//群号不存在
			//echo json_encode(array('state' => 1,'err-code' => 'x004')); 
			//die();
			$cnt1 = 0;
        	$sql = ' select count(group_id) as cnt from bc_member_group ';
	 		$sql.= ' where group_id ="'.$_REQUEST['m_sp_qunhao'].'"';
	 		$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 		$result = get_info_by_sql($sql);
	 		$cnt1 = $result[0]['cnt'];
	 		if($cnt1 == 0){
                echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	        die();
	 		}
		}
        $cnt = 0;
	 	$sql = ' select count(sproduct_code) as cnt from bc_service_product ';
	 	$sql.= ' where sproduct_name ="'.$_REQUEST['m_sp_name'].'"';
	 	$sql.= ' and sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and sproduct_code <> "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x005')); 
	 	    die();
	 	}
		//$sproduct_code = substr(md5(date('YmdHis').rand(1000, 9999)),8,16);
	 	$upinrow = array(
	 		'sproduct_name'=> $_REQUEST['m_sp_name'],
	 	    'sproduct_d_price'=> $_REQUEST['m_sp_price'],
	 	    'sproduct_q_code'=> $_REQUEST['m_sp_qunhao'],
	 	    'sproduct_from_at_id'=> $_REQUEST['m_sp_from_area'],
	 	    'sproduct_to_at_id'=> $_REQUEST['m_sp_to_area'],
	 		'sproduct_addtime'=> date('Y-m-d H:i:s'),
	 	    'sproduct_server_from_time'=> $_REQUEST['m_sp_start_time'],
	 	    'sproduct_server_to_time'=> $_REQUEST['m_sp_end_time'],
	 	    'sproduct_reference'=> $_REQUEST['m_sp_bcsm'],
	 	 'sproduct_dh_price_set'=> (int)$_REQUEST['m_sp_price_set'],
	 	'sproduct_dh_price_one'=> $_REQUEST['m_sp_price_one'],
	 	'sproduct_dh_price_two'=> $_REQUEST['m_sp_price_two'],
	 	'sproduct_dh_price_three'=> $_REQUEST['m_sp_price_three'],
	 	'sproduct_dh_price_four'=> $_REQUEST['m_sp_price_four'],
	 	
	 	'sproduct_dh_price_five'=> $_REQUEST['m_sp_price_five'],
	 	'sproduct_dh_price_six'=> $_REQUEST['m_sp_price_six'],
	 	);
	 	$result = update_service_product($_REQUEST['m_sp_code'],$upinrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	    $sql = ' select vip_apply_state,vip_apply_sp_code  from bc_vip_sproduct_apply  ';
	 	$sql.= ' where vip_apply_sp_code = "'.$_REQUEST['m_sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$vip_apply_state = $result[0]['vip_apply_state'];
        if($vip_apply_state <> 0){
	 	    $inrow2 = array(
	 		'vip_apply_sp_code'=> $_REQUEST['m_sp_code'],
	 	    'vip_apply_state'=> 0,
	 		'vip_apply_addtime'=> date('Y-m-d H:i:s'),
	 	    );
	 	    $result = update_vip_sproduct_apply2($_REQUEST['m_sp_code'],$inrow2);
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//添加常用地址
	function adduAddress(){
	    if(!$_REQUEST['m_address']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(!$_REQUEST['m_address_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(ua_id) as cnt from bc_useful_addresses ';
	 	$sql.= ' where ua_name ="'.$_REQUEST['m_address_name'].'"';
	 	$sql.= ' and ua_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	    die();
	 	}
	 	$inrow = array(
	 		'ua_m_code'=> $_REQUEST['m_code'],
	 		'ua_name'=> $_REQUEST['m_address_name'],
	 	    'ua_address'=> $_REQUEST['m_address'],
	 	    'ua_latitudee6'=> $_REQUEST['ua_latitudee6'],
	 	    'ua_longitudee6'=> $_REQUEST['ua_longitudee6'],
	 		'ua_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = add_useful_addresses($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//常用地址列表
	function getAddressList(){
		$sql = ' select ua_id,ua_name,ua_address from bc_useful_addresses ';
	 	$sql.= ' where ua_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	//if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//常用地址
	function edituAddress(){
	if(!$_REQUEST['m_address']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x002')); 
			die();
		}
	    if(!$_REQUEST['m_address_name']){	//参数m_shop_address 不能为空
			echo json_encode(array('state' => 1,'err-code' => 'x003')); 
			die();
		}
	    $cnt = 0;
	 	$sql = ' select count(ua_id) as cnt from bc_useful_addresses ';
	 	$sql.= ' where ua_name ="'.$_REQUEST['m_address_name'].'"';
	 	$sql.= ' and ua_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and ua_id <> '.(int)$_REQUEST['ua_id'];
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	    die();
	 	}
	 	$uprow = array(
	 		'ua_name'=> $_REQUEST['m_address_name'],
	 	    'ua_address'=> $_REQUEST['m_address'],
	 	    'ua_latitudee6'=> $_REQUEST['ua_latitudee6'],
	 	    'ua_longitudee6'=> $_REQUEST['ua_longitudee6'],
	 		'ua_uptime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = update_useful_addresses($_REQUEST['ua_id'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
	function addTixian(){
		//会员密码对不
	    $cnt = 0;
	 	$sql = ' select count(member_code) as cnt from bc_member ';
	 	$sql.= ' where member_password ="'.$_REQUEST['m_password'].'"';
	 	$sql.= ' and member_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
	 	    die();
	 	}
	    $cnt = 0;
	 	$sql = ' select count(tixian_id) as cnt from bc_tixian ';
	 	$sql.= ' where tixian_addtime like "'.date('Y-m-d').'%"';
	 	$sql.= ' and tixian_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	    $sql = ' select member_code,member_pwd_date,member_mobile from bc_member ';
	 	//$sql.= ' where member_password ="'.$_REQUEST['m_password'].'"';
	 	$sql.= ' where member_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	//$cnt = $result[0]['cnt'];
	 	if(false === $result){
            echo json_encode(array('state' => 1,'err-code' => 'x001')); 
	 	    die();
	 	}
	 	$member_pwd_date = "";
	 	$member_pwd_date = $result[0]['member_pwd_date'];
	 	$member_mobile= $result[0]['member_mobile'];
	 	if(str_replace("null", "", $member_pwd_date) != ''){
	 	if(getDayNum($member_pwd_date,date('Y-m-d')) <= 15){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x004')); 
	 	    die();
	 	}
	 	}
	 	$inrow = array(
	 		'tixian_m_code'=> $_REQUEST['m_code'],
	 		'tixian_name'=> $_REQUEST['m_alipay'],
	 	    'tixian_price'=> $_REQUEST['m_tx_price'],
	 		'tixian_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	$result = add_tixian($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	//发送通知
		$setCon = "亲，您的提现申请已经提交成功。我们会在24小时内进行处理！ 【路路帮】";
		//echo $setCon,"===",$_REQUEST['m_mobile'];
		$returnResult = setSms($member_mobile,$setCon);
		//判断发送是否成功
		//$resultResult = explode(',',$returnResult);
		//if($resultResult[0] == 1)
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	
	//*展示无用
	function getChatLogs(){
		$list = array();
		//系统消息4
		//群聊 3
		//对话消息 未读取的 2
		$chats_ids ='';
		$sql = ' select  a.chats_id, a.chats_content, a.chats_to_m_code, a.chats_from_m_code, a.chats_addtime  
	     ,b.member_name as from_m_name,b.member_logo as from_m_logo,2 as chats_type,a.chats_is_receive
	       from bc_chats a ';
	    $sql.= ' left join  bc_member b on a.chats_from_m_code=b.member_code ';
	 	$sql.= ' where a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' order by  a.chats_addtime desc ';
	 	$result = get_info_by_sql($sql);
	 	foreach ($result as $key => $value){
	 		$list[] = $value;
	 		if($chats_ids != '')$chats_ids.=',';
	 		$chats_ids.=$value['chats_id'];
	 	}
	 	unset($sql,$result);
		//记录 1
		$sql = 'select * from ( select  a.chats_id, a.chats_content, a.chats_to_m_code, a.chats_from_m_code, a.chats_addtime  
	     ,b.member_name as from_m_name,b.member_logo as from_m_logo ,1 as chats_type,a.chats_is_receive
	       from bc_chats a ';
	    //$sql.= ' left join  bc_member b on a.chats_to_m_code=b.member_code ';
	    $sql.= ' left join  bc_member b on a.chats_from_m_code=b.member_code ';
	 	$sql.= ' where (a.chats_from_m_code ="'.$_REQUEST['m_code'].'" ';
	 	$sql.= ' or a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' order by  a.chats_to_m_code desc,a.chats_addtime desc) as c ';
	 	if($chats_ids != '')
	 	    $sql.= ' where c.chats_id not in ('.$chats_ids.')';
	 	$sql.= ' group by c.chats_to_m_code ';
	 	$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	 		$list[] = $value;
	 	}
		echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
	//获取聊天信息 未读的
	function getChatLogsBySelf(){
		$list = array();
		//对话
		$sql = ' select  a.chats_id, a.chats_content, a.chats_to_m_code, a.chats_from_m_code, a.chats_addtime  
	     ,b.member_name as from_m_name,b.member_logo as from_m_logo,a.chats_is_receive
	       from bc_chats a ';
	    $sql.= ' left join  bc_member b on a.chats_from_m_code=b.member_code ';
	 	$sql.= ' where a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and a.chats_is_receive = 0 ';
	 	if($_REQUEST['m_time'])$sql.= ' and unix_timestamp(a.chats_addtime) > unix_timestamp("'.$_REQUEST['m_time'].'")';
	 	$result = get_info_by_sql($sql);
	 	$tmp = array();
	 	foreach ($result as $key => $value){
	 		$tmp['n_id'] = $value['chats_id'];
	 		$tmp['n_content'] = $value['chats_content'];
	 		$tmp['n_title'] = $value['from_m_name'];
	 		$tmp['n_logo'] = $value['from_m_logo'];
	 		$tmp['n_receive'] = $value['chats_is_receive'];
	 		$tmp['n_to_m_code'] = $value['chats_to_m_code'];
	 		$tmp['n_from_m_code'] = $value['chats_from_m_code'];
	 		$tmp['n_addtime'] = $value['chats_addtime'];
	 		$tmp['n_d_code'] = '';
	 		$tmp['n_type'] = 0;
	 		$list[] = $tmp;
	 		$tmp = array();
	 	}
	 	unset($result,$sql);
	 	//消息
	 	$sql = ' select  notice_id,notice_title,notice_content,notice_is_receive,notice_addtime,notice_to_m_code,notice_d_code  from bc_notice  ';
	 	$sql.= ' where notice_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and notice_is_receive = 0 ';
	 	if($_REQUEST['m_time'])$sql.= ' and unix_timestamp(notice_addtime) > unix_timestamp("'.$_REQUEST['m_time'].'")';
	 	$sql.= ' order by notice_addtime desc ';
	 	$result = get_info_by_sql($sql);
	 	$tmp = array();
	 	foreach ($result as $key => $value){
	 		$tmp['n_id'] = $value['notice_id'];
	 		$tmp['n_content'] = $value['notice_content'];
	 		$tmp['n_title'] = $value['notice_title'];
	 		$tmp['n_logo'] = "";
	 		$tmp['n_receive'] = $value['notice_is_receive'];
	 		$tmp['n_to_m_code'] = $value['notice_to_m_code'];
	 		$tmp['n_from_m_code'] = "";
	 		$tmp['n_addtime'] = $value['notice_addtime'];
	 		$tmp['n_d_code'] = $value['notice_d_code'];
	 		$tmp['n_type'] = 1;
	 		$list[] = $tmp;
	 		$tmp = array();
	 	}
	 	
	 	unset($result,$sql);
	 	//消息 系统公告
	 	$sql = ' select member_code,member_mobile from bc_member where member_code="'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$member_mobile = $result[0]['member_mobile'];
	 	unset($result,$sql);
	 	$sql = ' select  s_notice_id,s_notice_title,s_notice_content,s_notice_is_receive_code,s_notice_addtime,s_notice_to_m_mobile  from bc_s_notice  ';
	 	//$sql.= ' where notice_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' where s_notice_id <> 0 ';
	 	$sql.= ' and ((s_notice_to_m_mobile like "%'.$member_mobile.'%")';
	 	$sql.= ' or (s_notice_to_m_mobile =""))';
	 	if($_REQUEST['m_time'])$sql.= ' and unix_timestamp(s_notice_addtime) > unix_timestamp("'.$_REQUEST['m_time'].'")';
	 	$sql.= ' order by s_notice_addtime desc ';
	 	$result = get_info_by_sql($sql);
	 	//print_r($result);
	 	$tmp = array();
	 	foreach ($result as $key => $value){
	 		if($value['s_notice_is_receive_code']){
	 		if(str_replace($_REQUEST['m_code'], "", $value['s_notice_is_receive_code'])!=$value['s_notice_is_receive_code'])continue;
	 		}
	 		
	 		$tmp['n_id'] = $value['s_notice_id'];
	 		$tmp['n_content'] = $value['s_notice_content'];
	 		$tmp['n_title'] = $value['s_notice_title'];
	 		$tmp['n_logo'] = "";
	 		$tmp['n_receive'] = 0;
	 		$tmp['n_to_m_code'] = $_REQUEST['m_code'];
	 		$tmp['n_from_m_code'] = "";
	 		$tmp['n_addtime'] = $value['s_notice_addtime'];
	 		$tmp['n_d_code'] = '';
	 		$tmp['n_type'] = 2;
	 		$list[] = $tmp;
	 		$tmp = array();
	 	}
	 	unset($result,$sql);
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
    //获取朋友圈信息
	function getCfrindsBySelf(){
		$m_cds = '';
		$sql = ' select friends_l_m_code,friends_r_m_code from bc_friends ';
		$sql.= ' where friends_l_m_code ="'.$_REQUEST['m_code'].'"';
		$sql.= ' or friends_r_m_code ="'.$_REQUEST['m_code'].'"';
		$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	 		if($m_cds != '')$m_cds.=',';
	 		if($_REQUEST['m_code'] == $value['friends_l_m_code']){
	 			$m_cds.='"'.$value['friends_r_m_code'].'"';
	 		}else{
	 			$m_cds.='"'.$value['friends_l_m_code'].'"';
	 		}
	 	}
		unset($sql,$result);
		if($m_cds != '')$m_cds.=',';$m_cds.='"'.$_REQUEST['m_code'].'"';
		//echo $m_cds;
		$sql = ' select  a.cfriends_id, a.cfriends_m_code, a.cfriends_content, a.cfriends_maps
	     ,b.member_name as m_name,b.member_logo as m_logo,a.cfriends_addtime
	       from bc_cfriends a ';
	    $sql.= ' left join  bc_member b on a.cfriends_m_code=b.member_code ';
	 	//$sql.= ' where a.chats_to_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' where a.cfriends_id <> 0 ';
	 	if($m_cds != ''){
	 		$sql.= ' and a.cfriends_m_code in ('.$m_cds.') ';
	 	}else{
	 		$sql.= ' and a.cfriends_m_code  ="'.$_REQUEST['m_code'].'"';
	 	}
	 	    
	 	if($_REQUEST['m_time']){
	 	    $sql.= ' and unix_timestamp(a.cfriends_addtime) > unix_timestamp("'.$_REQUEST['m_time'].'")';
	 	}else{
	 		$sql.= ' limit 0,15 ';
	 	}
	 	//echo $sql;
	 	$result = get_info_by_sql($sql);
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//添加朋友圈信息
	function addCFriends(){
	    //判断是否 发 -天 内  超过 15
    	$cnt = 0;  
    	$sql = ' select count(cfriends_id) as cnt from bc_cfriends ';
	 	$sql.= ' where cfriends_m_code = "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and cfriends_addtime like "'.date('Y-m-d').'%" ';
	 	$result = get_info_by_sql($sql);
    	$cnt = $result[0]['cnt'];
    	if($cnt >= 15){
    		echo json_encode(array('state' => 1,'err-code' => 'x002'));//这1天内未信息已经有15条了，请删除一些没用的信息！ 
	 	    die();
    	}
    	$inrow = array(
	 		'cfriends_m_code'=> $_REQUEST['m_code'],
	 	    'cfriends_content'=> $_REQUEST['m_content'],
	 	    'cfriends_maps'=> $_REQUEST['map_names'],
	 		'cfriends_addtime'=> date('Y-m-d H:i:s'),
	 		);
	 	$result = add_cfriends($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
		
	}
	//获取朋友信息
	function getFriends(){
		$list = array();
		$tmp = array();
		$sql = ' select a.friends_id,a.friends_l_m_code,a.friends_r_m_code
	     ,b.member_name as m_l_name,b.member_logo as m_l_logo,c.member_name as m_r_name
	     ,c.member_logo as m_r_logo,a.friends_addtime
	       from bc_friends a ';
	    $sql.= ' left join bc_member b on a.friends_l_m_code=b.member_code ';
	    $sql.= ' left join bc_member c on a.friends_r_m_code=c.member_code ';
	 	$sql.= ' where (a.friends_l_m_code ="'.$_REQUEST['m_code'].'"';
		$sql.= ' or a.friends_r_m_code ="'.$_REQUEST['m_code'].'") ';
		$sql.= ' and a.friends_state = 1 ';
	 	//if($m_cds != '')
	 	//    $sql.= ' and a.cfriends_m_code in ('.$m_cds.') ';
	 	if($_REQUEST['m_time']){
	 	    $sql.= ' and unix_timestamp(a.friends_addtime) > unix_timestamp("'.$_REQUEST['m_time'].'")';
	 	}else{
	 		//$sql.= ' limit 0,15 ';
	 	}
	 	//echo $sql;
	 	$result = get_info_by_sql($sql);
	 	foreach ($result as $key => $value){
	 		$tmp = array();$tmp['mf_addtime']=$value['friends_addtime'];
	 		$tmp['mf_id']=$value['friends_id'];
	 		if($value['friends_l_m_code']==$_REQUEST['m_code']){
	 			$tmp['mf_code']=$value['friends_r_m_code'];
	 			$tmp['mf_name']=$value['m_r_name'];
	 			$tmp['mf_logo']=$value['m_r_logo'];
	 		}else{
	 			$tmp['mf_code']=$value['friends_l_m_code'];
	 			$tmp['mf_name']=$value['m_l_name'];
	 			$tmp['mf_logo']=$value['m_l_logo'];
	 		}
	 		$list[] = $tmp;
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
	
	//搜索会员
	function searchFriends(){
		$m_cds = '';
		$sql = ' select friends_l_m_code,friends_r_m_code from bc_friends ';
		$sql.= ' where (friends_l_m_code ="'.$_REQUEST['m_code'].'"';
		$sql.= ' or friends_r_m_code ="'.$_REQUEST['m_code'].'")';
		$sql.= ' and  friends_state = 1 ';
		$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	 		if($m_cds != '')$m_cds.=',';
	 		if($_REQUEST['m_code'] == $value['friends_l_m_code']){
	 			$m_cds.='"'.$value['friends_r_m_code'].'"';
	 		}else{
	 			$m_cds.='"'.$value['friends_l_m_code'].'"';
	 		}
	 	}
		unset($sql,$result);
		$sql = ' select member_code as m_code,member_logo as m_logo,member_name as m_name,member_mobile as m_mobile
	       from bc_member ';
		$sql.= ' where (member_mobile = "'.$_REQUEST['m_content'].'"';
		$sql.= ' or member_name ="'.$_REQUEST['m_content'].'" )';
		$sql.= '  and member_code <> "'.$_REQUEST['m_code'].'"';
		if($m_cds != '')
	 	    $sql.= ' and member_code not in ('.$m_cds.') ';
		$result = get_info_by_sql($sql);
		//echo $sql;
		echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//会员详细
	function getSearchFriendsDes(){
		$sql = ' select member_code as m_code,member_logo as m_logo,member_name as m_name
		,member_mobile as m_mobile,member_signature as m_sign,member_sex as m_sex
	       from bc_member ';
		$sql.= ' where member_code = "'.$_REQUEST['fm_code'].'"';
		$result = get_info_by_sql($sql);
		if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','m_logo' => $result[0]['m_logo'],'m_sex' => $result[0]['m_sex']
	 	,'m_name' => $result[0]['m_name'],'m_mobile' => $result[0]['m_mobile'],'m_sign' => $result[0]['m_sign']
	 	));
	}
	//朋友 申请的
	function getFriendsApply(){
		$sql = ' select a.friends_id,a.friends_l_m_code as m_code,b.member_logo as m_logo,b.member_name as m_name,
		a.friends_reference as m_about from bc_friends a ';
		$sql.= ' left join bc_member b on a.friends_l_m_code=b.member_code ';
		$sql.= ' where a.friends_r_m_code ="'.$_REQUEST['m_code'].'"';
		$sql.= ' and a.friends_state = 0 ';
		$result = get_info_by_sql($sql);
		echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	function changeFriends(){
		$inrow = array(
	 	    'friends_state'=> (int)$_REQUEST['fm_state'],
	 	);
		
		$result = update_friends($_REQUEST['friends_id'],$inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//添加朋友
	function addFriend(){
	    $cnt = 0;
	 	$sql = ' select count(friends_id) as cnt from bc_friends ';
	 	$sql.= ' where ((friends_r_m_code ="'.$_REQUEST['fm_code'].'"';
	 	$sql.= ' and friends_l_m_code = "'.$_REQUEST['m_code'].'")';
	 	$sql.= ' or (friends_r_m_code ="'.$_REQUEST['m_code'].'"';
	 	$sql.= ' and friends_l_m_code = "'.$_REQUEST['fm_code'].'"))';
	 	$sql.= ' and friends_state <> 2 ';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
	 	    die();
	 	}
	 	unset($sql,$result);
	 	$time = date('Y-m-d H:i:s');
	 	$inrow = array(
	 	    'friends_reference'=> $_REQUEST['fm_content'],
	 		'friends_l_m_code'=> $_REQUEST['m_code'],
	 		'friends_r_m_code'=> $_REQUEST['fm_code'],
	 		'friends_addtime'=> $time,
	 	);
	 	
	 	$result = add_friends($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','friends_id' => $result,'friends_time'=>$time));
	 	die();
	}
	//群
	function getMyQuns(){
		$list = array();
		//自己的群
		$sql = ' select group_name as q_name, group_code as q_code,0 as q_type
	       from bc_member_group ';
		$sql.= ' where group_m_code = "'.$_REQUEST['m_code'].'"';
		$sql.= ' order by group_addtime asc ';
		$result = get_info_by_sql($sql);
		foreach ($result as $key => $value){
	 		$list[]=$value;
	 	}
		unset($sql,$result);
		//加入的群
		$sql = ' select b.group_name as q_name, b.group_code as q_code,1 as q_type
	       from bc_group_m a ';
		$sql.= ' left join  bc_member_group b on a.groupm_g_code=b.group_code ';
		$sql.= ' where a.groupm_m_code = "'.$_REQUEST['m_code'].'"';
		$result = get_info_by_sql($sql);
		foreach ($result as $key => $value){
	 		$list[]=$value;
	 	}
		unset($sql,$result);
		echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
	//建群
	function addQun(){
		//取得个数
	    $cnt = 0;
	 	$sql = ' select count(group_code) as cnt from bc_member_group ';
	 	$sql.= ' where group_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt >=10 ){
            echo json_encode(array('state' => 1,'err-code' => 'x002')); 
	 	    die();
	 	}
	 	//群的名字
	    $cnt = 0;
	 	$sql = ' select count(group_code) as cnt from bc_member_group ';
	 	$sql.= ' where group_name = "'.$_REQUEST['q_name'].'"';
	 	$sql.= ' and group_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
            echo json_encode(array('state' => 1,'err-code' => 'x003')); 
	 	    die();
	 	}
	 	$group_code = substr(date('Ymd'), 2).rand(10,99);
		$inrow = array(
	 		'group_m_code'=> $_REQUEST['m_code'],
	 		'group_code'=> $group_code,
		    'group_name'=> $_REQUEST['q_name'],
	 		'group_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	
	 	$result = add_member_group($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','q_code' => $group_code));
	 	die();
	}
	function delQun(){
		$result = del_member_group($_REQUEST['q_code']);
		if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//qun info
	function getQunInfo(){
		//群主信息
		$sql = ' select a.group_code,a.group_name,a.group_m_code,a.group_addtime,
		b.member_name,b.member_logo,b.member_mobile,c.pcount
	       from bc_member_group a ';
		$sql.= ' left join  bc_member b on a.group_m_code=b.member_code ';
		$sql.= ' left join  (select groupm_g_code,count(groupm_m_code) as pcount from bc_group_m group by groupm_g_code) 
		c on c.groupm_g_code=a.group_code ';
		$sql.= ' where a.group_code = "'.$_REQUEST['q_code'].'"';
		$result_o = get_info_by_sql($sql);
	    if(false === $result_o){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
		unset($sql);
		$sql = ' select a.groupm_m_code as m_code, b.member_name as m_name,b.member_logo as m_logo from bc_group_m a ';
		$sql.= ' left join  bc_member b on a.groupm_m_code=b.member_code ';
		$sql.= ' where a.groupm_g_code = "'.$_REQUEST['q_code'].'"';
		$result = get_info_by_sql($sql);
		
		echo json_encode(array('state' => 0,'err-code' => '','q_code' => $result_o[0]['group_code'],'q_name' => $result_o[0]['group_name']
		,'m_name' => $result_o[0]['member_name'],'m_code' => $result_o[0]['group_m_code'],'m_logo' => $result_o[0]['member_logo']
		,'m_mobile' => $result_o[0]['member_mobile'],'q_pcount' => (int)$result_o[0]['pcount']+1,'q_time' => $result_o[0]['group_addtime'],'list' => $result));
	 	die();
	}
	//退出群
	function exitQun(){
		$result = exit_member_group($_REQUEST['q_code'],$_REQUEST['m_code']);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//提出群
	function tichuQun(){
		$result = exit_member_group($_REQUEST['q_code'],$_REQUEST['m_p_code']);
	    if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//搜索会员
	function searchMembers(){
		$m_cds = '';
		$sql = ' select groupm_id,groupm_m_code  from bc_group_m ';
		$sql.= ' where groupm_g_code = "'.$_REQUEST['q_code'].'"';
		$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	 		if($m_cds != '')$m_cds.=',';
	 		$m_cds.='"'.$value['groupm_m_code'].'"';
	 	}
	 	unset($sql,$result);
		$sql = ' select member_code as m_code,member_logo as m_logo,member_name as m_name,member_mobile as m_mobile
	       from bc_member ';
		$sql.= ' where (member_mobile like "'.$_REQUEST['m_content'].'%"';
		$sql.= ' or member_name like "%'.$_REQUEST['m_content'].'%" )';
		$sql.= ' and member_code <> "'.$_REQUEST['m_code'].'"';
		if($m_cds != '')
	 	    $sql.= ' and member_code not in ('.$m_cds.') ';
		$result = get_info_by_sql($sql);
		echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//加入群
	function addMtoQun(){
		$inrow = array(
	 		'groupm_g_code'=> $_REQUEST['q_code'],
	 		'groupm_m_code'=> $_REQUEST['fm_code'],
	 		'groupm_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	
	 	$result = add_group_m($inrow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//搜索商家
	function searchShopMembers(){
		$list =array();
		//m_city m_type m_search_for
		$sql = ' select a.member_code as m_code,a.member_logo as m_logo,a.member_name as m_name,
		a.member_mobile as m_mobile,b.sp_cnt  from bc_member a ';
		$sql.= 'left join  (select i.sproduct_m_code ,count(i.sproduct_code) as sp_cnt  
		  from bc_service_product i ';
		$sql.= '  left join bc_address_type j on i.sproduct_from_at_id=j.at_id  ';
		$sql.= '  left join bc_address_type k on i.sproduct_to_at_id=k.at_id ';
		$sql.= ' where (j.at_address_xz like "%'.$_REQUEST['m_city'].'%"';
		$sql.= ' or k.at_address_xz like "%'.$_REQUEST['m_city'].'%" )';
		$sql.= ' and i.sproduct_state = 1 ';   
		if($_REQUEST['m_type'])
		   $sql.= ' and i.sproduct_type ='.$_REQUEST['m_type'];
		$sql.= '  group by i.sproduct_m_code ) b on a.member_code=b.sproduct_m_code  ';
		$sql.= ' where a.member_code <>""';
		if($_REQUEST['m_search_for']){
			if($_REQUEST['m_search_for'] == 1)
			   $sql.= ' and a.member_name like "'.$_REQUEST['m_content'].'%"';
			if($_REQUEST['m_search_for'] == 2)
			   $sql.= ' and a.member_mobile like "'.$_REQUEST['m_content'].'%"';
		}else{
			$sql.= ' and (a.member_mobile like "'.$_REQUEST['m_content'].'%"';
		    $sql.= ' or a.member_name like "%'.$_REQUEST['m_content'].'%" )';
		}
		$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	 		if($value['sp_cnt'] == null)continue;
	 		if($value['sp_cnt'] == 0)continue;
	    	$list[] =$value;
	 	}
		echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
	//搜索商品 (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(a.demand_addtime)) 
	function searchProducts(){
		$sql = ' select a.sproduct_code as sp_code,a.sproduct_type as sp_type,a.sproduct_p_price as sp_p_price,
		a.sproduct_d_price as sp_d_price,a.sproduct_dr_price as sp_dr_price,a.sproduct_name as sp_name,
		a.sproduct_server_from_time as sp_s_time, a.sproduct_server_to_time as sp_e_time,
		a.sproduct_is_vip as sp_vip,b.at_name as sp_from_area,c.at_name as sp_to_area
		  from bc_service_product a ';
		$sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_state = 1 ';
	 	$sql.= ' and (b.at_address_xz like "'.$_REQUEST['m_city_s'].'%"';
		$sql.= ' or c.at_address_xz like "'.$_REQUEST['m_city_e'].'%" )';
		if($_REQUEST['m_type'])
		   $sql.= ' and a.sproduct_type ='.$_REQUEST['m_type'];
		$time =":00";
		
		//   $sql.= ' and unix_timestamp(a.sproduct_server_from_time) > unix_timestamp("'.str_replace("_", " ",$_REQUEST['c_addtime']).'")';
       // if($_REQUEST['m_time_s'])
		 //  $sql.= ' and unix_timestamp("'.date('Y-m-d ').'a.sproduct_server_from_time'.$time.'") <=unix_timestamp("'.date('Y-m-d ').$_REQUEST['m_time_s'].$time.'")';
		//if($_REQUEST['m_time_e'])
		 //  $sql.= ' and SECOND(a.sproduct_server_to_time) >=SECOND('.$_REQUEST['m_time_e'].')';
	    //if($_REQUEST['m_search_for']){
		//	if($_REQUEST['m_search_for'] == 1)
		//	   $sql.= ' and a.sproduct_name like "'.$_REQUEST['m_content'].'%"';
		//	if($_REQUEST['m_search_for'] == 2){
		//	    $sql.= ' and (b.at_address_xz like "%'.$_REQUEST['m_content'].'%"';
		//        $sql.= ' or c.at_address_xz like "%'.$_REQUEST['m_content'].'%")';
		//	}
		//}else{
			$sql.= ' and a.sproduct_name like "%'.$_REQUEST['m_content'].'%"';
		    //$sql.= ' or (b.at_address_xz like "%'.$_REQUEST['m_content'].'%"';
		   // $sql.= ' or c.at_address_xz like "%'.$_REQUEST['m_content'].'%" ))';
		//}
	 	//$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	//echo $sql;
	 	$result = get_info_by_sql($sql);
	 	$list = array();
	    foreach ($result as $key => $value){
	    	if($_REQUEST['m_time_s']){
	    		if((int)str_replace(":", "", $value['sp_s_time']) >(int)str_replace(":", "", $_REQUEST['m_time_s']))continue;
	    	}
	        if($_REQUEST['m_time_e']){
	    		if((int)str_replace(":", "", $value['sp_e_time']) >(int)str_replace(":", "", $_REQUEST['m_time_e']))continue;
	    	}
	 		//if($value['sp_cnt'] == null)continue;
	 		//if($value['sp_cnt'] == 0)continue;
	    	$list[] =$value;
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	 	die();
	}
	//商品
    function getNewProducts(){
		$sql = ' select a.sproduct_code as sp_code,a.sproduct_type as sp_type,a.sproduct_p_price as sp_p_price,
		a.sproduct_d_price as sp_d_price,a.sproduct_dr_price as sp_dr_price,a.sproduct_name as sp_name,
		a.sproduct_server_from_time as sp_s_time, a.sproduct_server_to_time as sp_e_time,
		a.sproduct_is_vip as sp_vip,b.at_name as sp_from_area,c.at_name as sp_to_area
		  from bc_service_product a ';
		$sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_state = 1 ';
	 	
	 	$sql.= ' and a.sproduct_m_code <> "'.$_REQUEST['m_code'].'"';
	 	$sql.= ' order by a.sproduct_addtime desc ';
	 	$sql.= ' limit 0,5 ';
	 	$result = get_info_by_sql($sql);
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	//取得商家商品
	function getSJProducts(){
		$sql = ' select a.sproduct_code as sp_code,a.sproduct_type as sp_type,a.sproduct_p_price as sp_p_price,
		a.sproduct_d_price as sp_d_price,a.sproduct_dr_price as sp_dr_price,a.sproduct_name as sp_name,
		a.sproduct_server_from_time as sp_s_time, a.sproduct_server_to_time as sp_e_time,
		a.sproduct_is_vip as sp_vip,b.at_name as sp_from_area,c.at_name as sp_to_area
		  from bc_service_product a ';
		$sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_state = 1 ';
	 	$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['c_m_code'].'"';
	 	/*$sql.= ' and (b.at_address_xz like "%'.$_REQUEST['m_city'].'%"';
		$sql.= ' or c.at_address_xz like "%'.$_REQUEST['m_city'].'%" )';
		if($_REQUEST['m_type'])
		   $sql.= ' and a.sproduct_type ='.$_REQUEST['m_type'];
	    if($_REQUEST['m_search_for']){
			if($_REQUEST['m_search_for'] == 1)
			   $sql.= ' and a.sproduct_name like "'.$_REQUEST['m_content'].'%"';
			if($_REQUEST['m_search_for'] == 2){
			    $sql.= ' and (b.at_address_xz like "%'.$_REQUEST['m_content'].'%"';
		        $sql.= ' or c.at_address_xz like "%'.$_REQUEST['m_content'].'%")';
			}
		}else{
			$sql.= ' and (a.sproduct_name like "'.$_REQUEST['m_content'].'%"';
		    $sql.= ' or (b.at_address_xz like "%'.$_REQUEST['m_content'].'%"';
		    $sql.= ' or c.at_address_xz like "%'.$_REQUEST['m_content'].'%" ))';
		}*/
	 	//$sql.= ' and a.sproduct_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result));
	 	die();
	}
	
    //获取拼车商品信息
	function getSPPCInfoData(){
	    $sql = ' select a.sproduct_code,a.sproduct_name,a.sproduct_p_price,a.sproduct_q_code,a.sproduct_from_at_id,
	    a.sproduct_to_at_id,a.sproduct_server_from_time,a.sproduct_server_to_time,a.sproduct_reference,a.sproduct_m_code,
	    b.at_name as sp_from_area,c.at_name as sp_to_area,
	     a.sproduct_pc_price_set, a.sproduct_pc_price_one, a.sproduct_pc_price_bc, a.sproduct_pc_price_two, a.sproduct_pc_price_two_bc,
	     a.sproduct_pc_price_three, a.sproduct_pc_price_three_bc, a.sproduct_pc_price_four, a.sproduct_pc_price_four_bc, a.sproduct_pc_price_f_t,
	     a.sproduct_pc_price_f_t_bc, a.sproduct_pc_price_tmore, a.sproduct_pc_price_tmore_bc
	      from bc_service_product a ';
	    $sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_p_price' => $result[0]['sproduct_p_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference'],'sp_m_code' => $result[0]['sproduct_m_code']
	 	,'sp_from_area' => $result[0]['sp_from_area'],'sp_to_area' => $result[0]['sp_to_area']
	 	
	 	,'sp_price_set' => $result[0]['sproduct_pc_price_set']
	 	,'sp_price_one' => $result[0]['sproduct_pc_price_one'],'sp_price_bc' => $result[0]['sproduct_pc_price_bc']
	 	,'sp_price_two' => $result[0]['sproduct_pc_price_two'],'sp_price_two_bc' => $result[0]['sproduct_pc_price_two_bc']
	 	,'sp_price_three' => $result[0]['sproduct_pc_price_three'],'sp_price_three_bc' => $result[0]['sproduct_pc_price_three_bc']
	 	,'sp_price_four' => $result[0]['sproduct_pc_price_four'],'sp_price_four_bc' => $result[0]['sproduct_pc_price_four_bc']
	 	,'sp_price_f_t' => $result[0]['sproduct_pc_price_f_t'],'sp_price_f_t_bc' => $result[0]['sproduct_pc_price_f_t_bc']
	 	,'sp_price_tmore' => $result[0]['sproduct_pc_price_tmore'],'sp_price_tmore_bc' => $result[0]['sproduct_pc_price_tmore_bc']
	 	
	 	
	 	 ));
	 	die();
	}
    //获取代驾商品信息
	function getSPDJInfoData(){
		
	    $sql = ' select a.sproduct_code,a.sproduct_name,a.sproduct_dr_price,a.sproduct_q_code,a.sproduct_from_at_id,
	    a.sproduct_to_at_id,a.sproduct_server_from_time,a.sproduct_server_to_time,a.sproduct_reference,a.sproduct_m_code,
	    b.at_name as sp_from_area,c.at_name as sp_to_area
	      from bc_service_product a ';
	    $sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_dr_price' => $result[0]['sproduct_dr_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference'],'sp_m_code' => $result[0]['sproduct_m_code']
	 	,'sp_from_area' => $result[0]['sp_from_area'],'sp_to_area' => $result[0]['sp_to_area']
	 	 ));
	 	die();
	}
	//获取带货商品信息
	function getSPDHInfoData(){
		
	    $sql = ' select a.sproduct_code,a.sproduct_name,a.sproduct_d_price,a.sproduct_q_code,a.sproduct_from_at_id,
	    a.sproduct_to_at_id,a.sproduct_server_from_time,a.sproduct_server_to_time,a.sproduct_reference,a.sproduct_m_code,
	    b.at_name as sp_from_area,c.at_name as sp_to_area
	    
	    ,a.sproduct_dh_price_set,a.sproduct_dh_price_one,a.sproduct_dh_price_two,a.sproduct_dh_price_three,
	    a.sproduct_dh_price_four,a.sproduct_dh_price_five,a.sproduct_dh_price_six
	      from bc_service_product a ';
	    
	 	$sql.= ' left join bc_address_type b on a.sproduct_from_at_id = b.at_id ';
		$sql.= ' left join bc_address_type c on a.sproduct_to_at_id = c.at_id ';
	 	$sql.= ' where a.sproduct_code = "'.$_REQUEST['sp_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	if(false === $result_at){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $result_at,
	 	  'sp_name' => $result[0]['sproduct_name'],'sp_d_price' => $result[0]['sproduct_d_price'],'sp_q_code' => $result[0]['sproduct_q_code'] , 
	 	  'sp_from_at_id' => $result[0]['sproduct_from_at_id'], 'sp_to_at_id' => $result[0]['sproduct_to_at_id'] ,
	 	 'sp_server_from_time' => $result[0]['sproduct_server_from_time'],'sp_server_to_time' => $result[0]['sproduct_server_to_time']
	 	,'sp_reference' => $result[0]['sproduct_reference'],'sp_m_code' => $result[0]['sproduct_m_code']
	 	,'sp_from_area' => $result[0]['sp_from_area'],'sp_to_area' => $result[0]['sp_to_area']
	 	
	 	,'sp_price_set' => $result[0]['sproduct_dh_price_set']
	 	,'sp_price_one' => $result[0]['sproduct_dh_price_one'],'sp_price_four' => $result[0]['sproduct_dh_price_four']
	 	,'sp_price_two' => $result[0]['sproduct_dh_price_two'],'sp_price_five' => $result[0]['sproduct_dh_price_five']
	 	,'sp_price_three' => $result[0]['sproduct_dh_price_three'],'sp_price_six' => $result[0]['sproduct_dh_price_six']
	 	 ));
	 	die();
	}
	
	//添加充值记录
	function addChongzhiLog(){
		$inrow = array(
	 		'recharge_code'=> $_REQUEST['m_cz_code'],
	 		'recharge_m_code'=> $_REQUEST['m_code'],
		    'recharge_price'=> $_REQUEST['m_cz_price'],
	 		'recharge_addtime'=> date('Y-m-d H:i:s'),
	 	);
	 	
	 	$result = add_recharge($inrow);
	 	$runsql = ' update bc_member set member_rmb = member_rmb+'.$_REQUEST['m_cz_price'].' where member_code ="'.$_REQUEST['m_code'].'"';
	 	run_by_sql($runsql);
	 	//if(false === $result){
	 	//    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	//    die();
	 	//}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	
	}
	//设置系统配置
	function setSystem(){
		$uprow = array(
	 		'member_loc_share'=> $_REQUEST['m_loc_share'],
	 		'member_voice_broadcast'=> $_REQUEST['m_voice_broadcast'],
		    'member_sound_reminder'=> $_REQUEST['m_sound_reminder'],
	 		'member_shaking_reminder'=> $_REQUEST['m_shaking_reminder'],
		    'member_receive_info'=> $_REQUEST['m_receive_info'],
		    'member_receive_range'=> $_REQUEST['m_receive_range'],
	 	);
		$result = update_member($_REQUEST['m_code'],$uprow);
	 	if(false === $result){
	 	    echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));
	 	die();
	}
	//添加反馈记录
	function addFeedback(){
		$cnt = 0;
	    $sql = ' select count(feedback_id) as cnt from bc_feedback ';
	 	$sql.= ' where feedback_addtime like "'.date('Y-m-d').'%"';
	 	$sql.= ' and feedback_m_code = "'.$_REQUEST['m_code'].'"';
	 	$result = get_info_by_sql($sql);
	 	$cnt = $result[0]['cnt'];
	 	if($cnt != 0){
           echo json_encode(array('state' => 1,'err-code' => 'x002')); //今日已经提交
	 	   die();
	 	}
	 	$uprow['feedback_m_code'] = $_REQUEST['m_code'];
	 	$uprow['feedback_content'] = $_REQUEST['m_feedback'];
	    $uprow['feedback_addtime'] = date('Y-m-d H:i:s');
	    $result = add_feedback($uprow);
	    if(false === $result){
	 	    	 echo json_encode(array('state' => 1,'err-code' => 'x001'));//服务器数据库开小差了哦！ 
	 	    	 die();
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => ''));//0k！
	}
	//获取通讯录中那些已经邀请
	function getInvites(){
		$list= array();
		$list_vle= array();
		$valuess= array();
		$m_mobiles = split("_", $_REQUEST['m_mobiles']);
		$sql = ' select member_code,member_mobile from bc_member ';
	 	$sql.= ' where member_mobile in ('.str_replace("_", ",",$_REQUEST['m_mobiles']).')';
	 	$result = get_info_by_sql($sql);
	    foreach ($result as $key => $value){
	    	$valuess[] = $value['member_mobile'];
	 	}
	 	
	 	foreach ($m_mobiles as $key => $value){
	 		$list_vle= array();
	 		$list_vle['m_mobile'] = $value;
	 		$list_vle['m_state'] = 1;
	 		if(in_array($value, $valuess))$list_vle['m_state'] =0;
	 		$list[] = $list_vle;
	 	}
	 	echo json_encode(array('state' => 0,'err-code' => '','list' => $list));
	}
	//删除朋友圈的图片
	function delCFMap(){
		unlink(APP_PATH.'/files/map/'.$_REQUEST['map_name']);
		echo json_encode(array('state' => 0,'err-code' => ''));
	}
	
}