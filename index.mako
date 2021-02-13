## -*- coding: utf-8 -*-
<%!
from template_lib import md
%>
<%inherit file="base.mako" />
<div class="row">
    <div class="col-sm-3 d-none d-lg-block">
        <nav class="nav flex-column nav-pills sticky-top" aria-orientation="vertical" id="content-navigation">
          <a class="nav-link active" href="#intro" role="tab">Introduction</a>
          <a class="nav-link" href="#install" role="tab">Installation</a>
          <a class="nav-link" href="#plugins" role="tab">Adding plugins</a>
          <a class="nav-link" href="#usage" role="tab">Usage</a>
          <a class="nav-link" href="#new-hooks" role="tab">Creating new hooks</a>
          <a class="nav-link" href="#cli" role="tab">Command line interface</a>
          <a class="nav-link" href="#advanced" role="tab">Advanced features</a>
          <a class="nav-link" href="#contributing" role="tab">Contributing</a>
        </nav>
    </div>
    <div class="col-lg-9 col-12">
        ${body}
    </div>
</div>
