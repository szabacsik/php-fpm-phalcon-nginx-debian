# 🚀 PHP Phalcon Nginx Debian Stack

**PHP + Phalcon + Nginx Container for Cloud Deployment**

A Docker image featuring PHP 8.4 with PHP-FPM, the high-performance Phalcon framework, and Nginx web server running on Debian Bookworm. Originally designed for **AWS App Runner** deployments, this container provides a complete web application stack for modern PHP development with the Phalcon framework.

## ✨ Key Features

- **PHP 8.4** with PHP-FPM for optimal performance
- **Phalcon 5.9.3** framework pre-installed and configured
- **Nginx** web server with optimized configuration
- **Debian Bookworm** base for stability and security
- **AWS App Runner ready** - optimized for seamless cloud deployment
- **Composer** package manager included
- **JSON API ready** with sample Phalcon Micro application
- **Container-friendly logging** to stdout/stderr
- **Multi-stage build** for a smaller final image size

## 🏷️ Version Tagging System

This image uses an automated versioning system that creates detailed tags based on the exact versions of all included components:

**Format:** `php{VERSION}-phc{VERSION}-ng{VERSION}-deb{VERSION}`

**Example:** `php8.4.14-phc5.9.3-ng1.22.1-deb12.12`
- `php8.4.14` - PHP-FPM version 8.4.14
- `phc5.9.3` - Phalcon framework version 5.9.3
- `ng1.22.1` - Nginx server version 1.22.1
- `deb12.12` - Debian base system version 12.12

This versioning ensures complete transparency about what's included in each image and allows you to pin to specific component versions for deployments.

## 🚀 Quick Start

```bash
docker run -d -p 8080:8080 szabacsik/php-fpm-phalcon-nginx-bookworm:latest
```

Access your application at `http://localhost:8080`. The image includes:
- **`/`** - JSON API status endpoint (Phalcon Micro application)
- **`/info.php`** - PHP configuration information page

## 🐳 Docker Hub Image

This project serves as the **source code** for a pre-built Docker image that's publicly available on Docker Hub:

**🔗 [szabacsik/php-fpm-phalcon-nginx-bookworm](https://hub.docker.com/repository/docker/szabacsik/php-fpm-phalcon-nginx-bookworm/general)**

### Key Benefits
- ✅ **Public & Free** - Anyone can pull and use the image
- ✅ **Pre-built** - No need to build from source
- ✅ **Regularly Updated** - Image is updated occasionally with the latest components
- ✅ **Multiple Tags** - Both `latest` and version-specific tags available

### Using the Pre-built Image

**Basic Usage:**
```bash
# Pull and run the latest version
docker pull szabacsik/php-fpm-phalcon-nginx-bookworm:latest
docker run -d -p 8080:8080 szabacsik/php-fpm-phalcon-nginx-bookworm:latest
```

**Using Specific Version:**
```bash
# Use a specific version tag for production stability
docker pull szabacsik/php-fpm-phalcon-nginx-bookworm:php8.4.14-phc5.9.3-ng1.22.1-deb12.12
docker run -d -p 8080:8080 szabacsik/php-fpm-phalcon-nginx-bookworm:php8.4.14-phc5.9.3-ng1.22.1-deb12.12
```

### Customization Examples

**1. Custom Application Deployment:**
```dockerfile
# Use the pre-built image as base
FROM szabacsik/php-fpm-phalcon-nginx-bookworm:latest

# Copy your application files
COPY ./my-app/ /var/www/html/

# Add custom configuration if needed
COPY ./my-nginx.conf /etc/nginx/nginx.conf
COPY ./my-php.ini /usr/local/etc/php/php.ini

# Install additional dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080
CMD ["/entrypoint.sh"]
```

**2. Development with Volume Mounting:**
```bash
# Mount your local code for development
docker run -d -p 8080:8080 \
  -v $(pwd)/my-app:/var/www/html \
  szabacsik/php-fpm-phalcon-nginx-bookworm:latest
```

**3. Docker Compose Integration:**
```yaml
version: '3.8'
services:
  web:
    image: szabacsik/php-fpm-phalcon-nginx-bookworm:latest
    ports:
      - "8080:8080"
    volumes:
      - ./app:/var/www/html
    environment:
      - PHP_MEMORY_LIMIT=256M
```

## 🛠️ Development & Management

This project is currently managed through Makefile commands. Future plans include CI/CD automation.

### Available Makefile Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make build` | Build the Docker image |
| `make start` | Start a container from the image |
| `make stop` | Stop and remove the container |
| `make logs` | View container logs |
| `make shell` | Open bash shell in a new container |
| `make versions` | Display versions of PHP, Phalcon, Nginx, and Debian as JSON |
| `make version-tag` | Output combined version tag |
| `make tag-latest` | Generate version tag and apply it to the built image |
| `make docker-login` | Log into Docker Hub |
| `make push-latest` | Push the latest tag to Docker Hub |
| `make push-version` | Tag and push versioned image to Docker Hub |
| `make push-all` | Push both latest and versioned tags to Docker Hub |

### Development Workflow

```bash
# Build the image
make build

# Start the container
make start

# View logs
make logs

# Open shell for debugging
make shell

# Stop the container
make stop
```

## 🎯 Use Cases

### Primary: AWS App Runner
This image is specifically crafted for AWS App Runner, Amazon's fully managed service for containerized web applications. Simply point App Runner to your Docker Hub repository and deploy your PHP/Phalcon applications with zero infrastructure management.

### Additional Use Cases
- Local Phalcon framework development
- High-performance PHP web applications
- REST API development and deployment
- Microservices architecture
- CI/CD pipeline integration
- Traditional web server environments

## ⚙️ Configuration

- **Port:** Nginx listens on port 8080 (App Runner compatible)
- **PHP-FPM:** Configured for container environments
- **Logging:** Error logging to stderr for container-friendly debugging
- **Security:** File uploads disabled by default
- **Sample App:** Phalcon Micro application with JSON API endpoints

## 📄 License & Usage

This project is **open source** and **free to use**. Anyone can:
- ✅ Fork this repository
- ✅ Use it for any purpose (personal, commercial, educational)
- ✅ Modify and distribute

Feel free to fork, modify, and use this project for any purpose you need!

---

*Built with ❤️ for the PHP and Phalcon community*