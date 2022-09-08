---
title: Spring Boot & 过滤器 & 拦截器 & 注册
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 过滤器
- 拦截器
---
# Spring Boot & 过滤器 & 拦截器 & 注册

---

[toc]

---
## 一、过滤器
```
@Component
public class UserFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request2=(HttpServletRequest) request;
		HttpServletResponse response2=(HttpServletResponse) response;
		
		String url=request2.getScheme()+"://"+request2.getServerName()+":"+request2.getServerPort()+request2.getSession().getServletContext().getContextPath()+"/";
		
		Object o=request2.getSession().getAttribute("user");

		System.out.println("进入过滤器！"+o);


        //得到当前页面所在目录下全名称
		String urlPattern=request2.getServletPath();
		
		//得到页面所在服务器的绝对路径
		String path = request2.getRequestURI();

	
		if(o==null){		
			System.out.println(2);
			response2.sendRedirect(url+"login.html");
		}else{
			System.out.println(3);
			chain.doFilter(request, response);
		}

	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}
}


```
## 二、拦截器

```
@Component
@AllArgsConstructor
@Slf4j
public class UserInterceptor implements HandlerInterceptor {
    private RedisUtils redisUtils;

    @Override
    public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
            throws Exception {

    }

    @Override
    public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
            throws Exception {

    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {
        log.info("request url : {} 进行用户拦截校验", request.getRequestURL().toString());
        //redis里获取缓存用户
        String jsonUser = redisUtils.get(String.format(RedisKey.USER_KEY, request.getHeader(SysConst.USER_TOKEN)));
        User user = new Gson().fromJson(jsonUser, User.class);
        if (ObjectUtil.isNotEmpty(user)) {
            log.info("user:{}放行", user.getName());
            return true;
        }
        log.info("拦截");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.getWriter().print(new Gson().toJson(Result.failed(ErrorEnum.E_202.getErrorMsg())));
        return false;
    }
}
```
## 三、注册

```
@Configuration
public class Config {
    private UserInterceptor userInterceptor;

    /**
     * 拦截器
     * */
    @Bean
    public WebMvcConfigurer WebMvcConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addInterceptors(InterceptorRegistry registry) {
                //排除无需拦截路径
                List<String> excludeList=new ArrayList<>();
                excludeList.add("/user/register");
                excludeList.add("/user/login");
                excludeList.add("/file/upload");
                excludeList.add("/file/list/**");
                //配置需要拦截路径/*
                registry.addInterceptor(userInterceptor)
                        .addPathPatterns("/file/**")
                        .addPathPatterns("/user/**")
                        .excludePathPatterns(excludeList);
            }
        };
    }
    /**
     * 过滤器
     * */
    @Bean
    public FilterRegistrationBean testFilterRegistration() {
        FilterRegistrationBean registration = new FilterRegistrationBean(userFilter);
        //配置需要过滤路径
        registration.addUrlPatterns("/index/*");
        registration.addUrlPatterns("/hospital/*");
        registration.addUrlPatterns("/medicine/*");
        registration.addUrlPatterns("/registration/*");
        registration.addUrlPatterns("/Resource/*");
        registration.addUrlPatterns("/Role/*");
        registration.addUrlPatterns("/User/*");
        registration.addUrlPatterns("/index/*");

        registration.setName("userFilter");
        return registration;
    }
}
```
