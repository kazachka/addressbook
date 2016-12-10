package com.kazachka.addressbook.controllers;

import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

@Controller
public class MainController {

    @GetMapping("/")
    public String home() {
        return "index";
    }
    
}
