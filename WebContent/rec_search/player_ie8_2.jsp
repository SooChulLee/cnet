<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String type  = request.getParameter("type");%>
<!--플레이어 영역-->
<div class="tableSize4">
	<div id="outer_player"></div>
</div>
<div class="tableSize4 player_nav">
	<!-- <div class="colLeft" style="margin-right: 10px;">
		<button name="btn_view_marking" class="btn btn-primary btn-xs">Marking</button>
		<button name="btn_download" class="btn btn-primary btn-xs hide">Down</button>
	</div> -->
	<div class="colLeft" style="margin-right: 10px;">
		<ul class="list-inline">
			<li>
				<input type="text" name="move_time" style="width: 65px;" value="1" class="form-control" maxlength="3" id="" placeholder=""/>
				<select name="move_unit" style="width: 45px;" class="form-control">
					<option value="M">분</option>
					<option value="S">초</option>
				</select>
			</li>
			<li class="btn btn-primary btn-xs" id="btn_forward">Fw</li>
			<li class="btn btn-primary btn-xs" id="btn_backward">Bw</li>
		</ul>
	</div>

	<div class="colLeft">
		<ul class="list-inline">
			<!--<li class="btn_speed btn btn-primary btn-xs" prop="0.5">0.5</li>-->
			<li class="btn_speed btn btn-success btn-xs" prop="1.0" style="margin-left: 2px;">1.0</li>
			<li class="btn_speed btn btn-primary btn-xs" prop="1.2" style="margin-left: 2px;">1.2</li>
			<li class="btn_speed btn btn-primary btn-xs" prop="1.5" style="margin-left: 2px;">1.5</li>
			<li class="btn_speed btn btn-primary btn-xs" prop="2.0" style="margin-left: 2px;">2.0</li>
		</ul>
	</div>
	<div class="colRight" style="margin-top: 3px;">
		<span id="cur_time">00:00</span> / <strong><span id="tot_time">00:00</span></strong>
	</div>
</div>

<script type="text/javascript"  for="player" event="playStateChange(NewState)">
	// play state change event
	switch (NewState){
		case 1:
			// stop
			onStop();
			break;
		case 2:
			// paused
			onPause();
			break;
		case 3:
			// play
			onProgress();
			break;
		case 8:
			// End
			onEnd(NewState);
			break;
		default:
			break;
	}
</script>
<!--플레이어 영역 끝-->