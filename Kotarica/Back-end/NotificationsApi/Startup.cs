using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using NotificationsApi.Database;
using NotificationsApi.Hubs;

namespace NotificationsApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<NotificationsApiDbContext>(opt =>
                /*opt.UseNpgsql(
                    "User ID=postgres;Password=1234;Server=localhost;Port=5432;Database=NotificationsApi;Integrated Security=true;Pooling=true",
                    options => options.SetPostgresVersion(new Version(9, 5))
                )*/
                opt.UseSqlite("Filename=database.sqlite;")
            );
            services.AddControllers();

            services.AddSignalR();

            services.AddCors(options =>
            {
                options.AddPolicy("AllowAll",
                    builder =>
                    {
                        builder
                        .AllowAnyOrigin() 
                        .AllowAnyMethod()
                        .AllowAnyHeader();
                    });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();
            app.UseRouting();
            app.UseAuthorization();
            app.UseCors("AllowAll");

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapHub<ChatHub>("/ChatHub");
            });
        }
    }
}
