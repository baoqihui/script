---
title: 常用js
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- js
---
# 常用js

---

[toc]

---

## 1.表单提交为json

```
//上传接口
  function addBasic() {
    console.log($('#basic').serializeJson())
    $.ajax({
      type: "POST",
      dataType: "json",
      url: '../basicInfo',
      contentType: "application/json",
      data:JSON.stringify($('#basic').serializeJson()),
      success: function (result) {
        console.log("data is :" + result)
        if (result.code == 200) {
          alert("登陆成功");
          window.location.href = "../home/home_page.html";
        }else {
          alert(result.message)
        }
      }
    });
  }
//form -->json
(function (window, $) {
    $.fn.serializeJson = function () {//form serialize to json
      var serializeObj = {};
      var array = this.serializeArray();
      $(array).each(
              function () {
                if (serializeObj[this.name]) {
                  if ($.isArray(serializeObj[this.name])) {
                    serializeObj[this.name].push(this.value);
                  } else {
                    serializeObj[this.name] = [
                      serializeObj[this.name], this.value];
                  }
                } else {
                  serializeObj[this.name] = this.value;
                }
              });
      return serializeObj;
    };
  })(window, jQuery);
```
## 2.上传图片

```
 //上传图片
$("#m_image_addr").live("change",function(){
        //注意这里不能写错。。。
        var file=$("#m_image_addr")[0].files[0];
        var formData = new FormData();
        formData.append("m_image_addr",file);
        //对文件类型进行判断
        var index=file.name.lastIndexOf(".");
        var type=file.name.substring(index);
        if(type!=".jpg"&&type!=".png"){
          alert("只能上传jpg和png格式的图片！！");
          return;
        }
        $.ajax({
          url:"../upload.do",
          data:formData,
          dataType:"text",
          type:"post",
          //这两个属性必须设置！！！！
          contentType: false,
          processData: false, //设置为true时，ajax提交的时候不会序列化data，而是直接使用data
          success:function (path) {
            $("#yulan").attr("src",path);
            $("input[name='imgUrl']").attr("value",path);
          }
        })
      })
```
## 3.加载前端数据到表单

```
//获取json接口
$.get("/basicInfo/"+$.cookie('id'),{},function(result){
      if (result.resp_code=="0"){
        loadData(result.datas);
      }else{
        $("#msg2").text(result.resp_msg);
      }
    },"json"){
      if (result.resp_code=="0"){
        loadData(result.datas);
      }else{
        $("#msg2").text(result.resp_msg);
      }
    },"json")
 //加载前端数据到表单
  function loadData(obj){
    if($.type(obj)!="object"){
      alert("页面初始化错误！");
      return false;
    }
    var key,value,tagName,type,arr;
    for(x in obj){
      key = x;
      value = obj[x];
      $("[name='"+key+"'],[name='"+key+"[]']").each(function(index){
        tagName = $(this)[0].tagName;
        type = $(this).attr('type');
        if (tagName=='IMG'){
          $(this).attr('src',value);
        }
        if(tagName=='INPUT'){
          if(type=='radio'){                      //处理radio
            $(this).attr('checked',$(this).val()==value);
          }else if(type=='checkbox'){             //处理checkbox
            for(var i =0;i<value.length;i++){
              if($(this).val()==value[i]){
                $(this).attr('checked',true);
                break;
              }
            }
          }else if(type=='date'){                  //处理日期型表单
            if(parseInt(value)>1000000000000)      //毫秒时间戳
              $(this)[0].valueAsNumber=parseInt(value);
            else if(parseInt(value)>1000000000)    //秒时间戳
              $(this)[0].valueAsNumber=parseInt(value)*1000;
            else                                   //字符串时间
              $(this)[0].valueAsDate=new Date(value);
          }else{
            if($.isArray(value))                    //表单组情形(多个同名表单)
              $(this).val(value[index]);
            else
              $(this).val(value);
          }
          //$(this).uniform();//自用！
        }else if(tagName=='SELECT'){    //处理select和textarea
          $(this).val(value);
        }
      });
    }
  }
```
## 4.单按钮开关

```
$("#daohang").click(
	function () {
		var isON=$(this).attr("isON");
		if(isON!="1"){//关闭状态
			$("#content ").css({'margin-left':'220px'});
			$("#sidebar").children("ul").css({'display': 'block'});
			$("#sidebar").show();
			$("#zhankai").text("关闭导航");
			isON=1;
		}else{//开启状态
			$("#content ").css({'margin-left':'0px'});
			$("#sidebar").children("ul").css({'display': 'none'});
			$("#sidebar").hide();
			$("#zhankai").text("展开导航");
			isON=0;
		}
		$(this).attr("isON",isON);
	}
)
```
## 5.回车提交事件

`	$("#verify").bind("keydown",function(event){ if(event.keyCode == "13") { }	})`