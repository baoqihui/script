---
title: Java中使用图片验证码
date:  2022/9/7 09:57
category_bar: true
categories: 学习笔记
tags:
- Java
- 图片验证码
---
# Java中使用图片验证码
---
## 一、第一种方式
1. 工具类
```
@WebServlet("/BufferImage")
public class BufferImage extends HttpServlet {
    public static final int WIDTH = 120;//生成图片的宽度
    public static final int HEIGHT = 30;//生成图片的高度
    public static final int WORDS_NUMBER = 4;//验证码中字符的个数
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	
    	req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html;charset=utf-8");
		
    	// TODO Auto-generated method stub
        String createTypeFlag = req.getParameter("createTypeFlag");//接收客户端传递的createTypeFlag标识
        //在内存中创建一张图片
        BufferedImage bi = new BufferedImage(WIDTH,HEIGHT,BufferedImage.TYPE_3BYTE_BGR);
        //得到图片
        Graphics g = bi.getGraphics();
        //设置图片的背景色
        setBackGround(g);
        //设置图片的边框
        setBorder(g);
        //在图片上画干扰线
        drawRandomLine(g);
        //在图片上放上随机字符
        String randomString = this.drawRandomNum((Graphics2D)g, createTypeFlag);
        System.out.println(randomString);
        //将随机数存在session中
        req.getSession().setAttribute("checkcode", randomString);
        
        //设置响应头通知浏览器以图片的形式打开
        resp.setContentType("image/jpeg");
        
        //设置响应头控制浏览器不要缓存
        resp.setDateHeader("expries", -1);
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Pragma", "no-cache");
        
        //将图片传给浏览器
        ImageIO.write(bi, "jpg", resp.getOutputStream());
    }
    
    //设置图片背景色
    //@param g
    private void setBackGround(Graphics g) {
        //设置颜色
        g.setColor(Color.WHITE);
        //填充区域
        g.fillRect(0, 0, WIDTH, HEIGHT);
    }
    
    /*
     * 设置图片的边框
     * @param g
     * */
    
    private void setBorder(Graphics g) {
        //设置边框颜色
        g.setColor(Color.BLUE);
        //边框区域
        g.drawRect(1, 1, WIDTH - 2, HEIGHT -2);
    }
    
    /*
     * 在图片上画随机线条 
     * @param g
     * */
    private void drawRandomLine(Graphics g) {
        //设置颜色
        g.setColor(Color.GREEN);
        //设置线条个数并画线
        for ( int i = 0 ; i < 7 ; i++ ) {
            int x1 = new Random().nextInt(WIDTH);
            int y1 = new Random().nextInt(HEIGHT);
            int x2 = new Random().nextInt(WIDTH);
            int y2 = new Random().nextInt(HEIGHT);
            g.drawLine(x1, y1, x2, y2);
        }
    }
    
    /*
     * 在图片上画随机字符
     * @param g
     * @param createTypeFlag
     * @return String
     * */
    private String drawRandomNum(Graphics g,String createTypeFlag) {
        //设置颜色
        g.setColor(Color.BLUE);
        g.setFont(new Font("宋体",Font.BOLD,20));
        
        //数字字母的组合
        String baseNumLetter = "0123456789ABCDEFGHJKLMNOPQRSTUVWXYZ";
        String baseNum = "0123456789";
        String baseLetter = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
        if ( createTypeFlag != null  && createTypeFlag.length() > 0 ) {
            if( createTypeFlag.equals("nl") ) {
                //截取数字和字母的组合
                return createRandomChar((Graphics2D) g,baseNumLetter);
            } else if ( createTypeFlag.equals("n") ) {
                //截取数字的组合
                return createRandomChar((Graphics2D) g,baseNum);
            } else if ( createTypeFlag.equals("l") ) {
                //截取字母的组合
                return createRandomChar((Graphics2D) g,baseLetter);
            }
        } else {
            //截取数字和字母的组合
            return createRandomChar((Graphics2D) g,baseNumLetter);
        }
        return "";
    }
    
    /*
     * 创建随机字符
     * @param g
     * @param baseChar
     * @return String
     * */
    private String createRandomChar(Graphics2D g , String baseChar) {
        StringBuffer b = new StringBuffer();
        int x = 5;
        String ch = "";
        for ( int i = 0 ; i < WORDS_NUMBER ; i++ ) {
            //设置字体的旋转角度
            int degree = new Random().nextInt() % 30;
            ch = baseChar.charAt(new Random().nextInt(baseChar.length())) + "";
            b.append(ch);
            
            //正向角度
            g.rotate(degree  * Math.PI / 180 , x,20);
            g.drawString(ch, x, 20);
            //反向角度
            g.rotate(-degree  * Math.PI / 180 , x,20);
            x+=30;
        }
        return b.toString();
    }
}
```
2. 后端
```
    @RequestMapping(value="/userLogin.do")

	public void userLogin(String code,HttpSession session){
		String cht=(String)session.getAttribute("checkcode");
		if(code.equalsIgnoreCase(cht)){
			System.out.println("验证码正确");
		}
	}
```
3. 前端
```
<form>
<img src="BufferImage" onclick="this.src='BufferImage?'+new Date().getTime()">看不清换一张<br><br>
验证码： <input type="text" id="verify" class="input-medium" placeholder="验证码">
<input type="submit" value="提交">
</form>
```

## 二、第二种方式（Spring Boot框架使用）
1. 工具类
```
package com.zhiyou.util;


import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

public final class BufferImage {

    // 验证码字符集
    private static final char[] chars = {
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
            'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    // 字符数量
    private static final int SIZE = 4;
    // 干扰线数量
    private static final int LINES = 8;
    // 宽度
    private static final int WIDTH = 100;
    // 高度
    private static final int HEIGHT = 32;
    // 字体大小
    private static final int FONT_SIZE = 25;

    /**
     * 生成随机验证码及图片
     * 数组中[验证码，图片]
     */
    public static Object[] createImage() {
        StringBuffer sb = new StringBuffer();
        // 1.创建空白图片
        BufferedImage image = new BufferedImage(
                WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        // 2.获取图片画笔
        Graphics graphic = image.getGraphics();
        // 3.设置画笔颜色
        graphic.setColor(new Color(216, 172, 203, 241));
        // 4.绘制矩形背景
        graphic.fillRect(0, 0, WIDTH, HEIGHT);

        // 5.画随机字符
        Random ran = new Random();
        for (int i = 0; i <SIZE; i++) {
            // 取随机字符索引
            int n = ran.nextInt(chars.length);
            // 设置随机颜色
            graphic.setColor(getRandomColor());
            // 设置字体大小
            graphic.setFont(new Font(
                    null, Font.BOLD + Font.ITALIC, FONT_SIZE));
            // 画字符
            graphic.drawString(
                    chars[n] + "", i * WIDTH / SIZE, HEIGHT/2+HEIGHT/8);
            // 记录字符
            sb.append(chars[n]);
        }
        // 6.画干扰线
        for (int i = 0; i < LINES; i++) {

            graphic.setColor(getRandomColor());
            // 随机画线
            graphic.drawLine(ran.nextInt(WIDTH), ran.nextInt(HEIGHT),
                    ran.nextInt(WIDTH), ran.nextInt(HEIGHT));
        }
        // 7.返回验证码和图片
        return new Object[]{sb.toString(), image};
    }

    /**
     * 随机取色
     */
    public static Color getRandomColor() {
        Random ran = new Random();
        Color color = new Color(ran.nextInt(256),
                ran.nextInt(256), ran.nextInt(256));
        return color;
    }

    public static void main(String[] args) throws IOException {
        Object[] objs = createImage();
        BufferedImage image = (BufferedImage) objs[1];
        OutputStream os = new FileOutputStream("src/main/resources/static/picture/eb1ccd3d99794795bc99553b0b762e73.gif");
        ImageIO.write(image, "png", os);
        os.close();
    }

}

```
2. 后台controller
```
/* **********************************图片验证码************************************* */
	@RequestMapping(value = "/BufferImage")
	protected void createImg(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		//1.生成随机的验证码及图片
		Object[] objs = BufferImage.createImage();
		//2.将验证码存入session
		String imgcode = (String) objs[0];
		HttpSession session = req.getSession();
		session.setAttribute("checkcode", imgcode);
		//3.将图片输出给浏览器
		BufferedImage img = (BufferedImage) objs[1];
		res.setContentType("image/png");
		//服务器自动创建输出流，目标指向浏览器
		OutputStream os = res.getOutputStream();
		ImageIO.write(img, "png", os);
		os.close();
	}
```
3. 验证和前台方式不变
