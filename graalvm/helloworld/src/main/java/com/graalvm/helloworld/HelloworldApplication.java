package com.graalvm.helloworld;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloworldApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(HelloworldApplication.class, args);
	}

	public void run(String... args) {
		System.out.println("Printing \n \n Hello World");
	}

}
